require 'csv'
require 'erb'

class Company < ActiveRecord::Base
  has_many :brands
  has_many :collections
  has_many :products
  has_many :variants, :through => :products
  has_many :imports

  #before_save :preview_first # not previewing first

  #accepts_nested_attributes_for :products, :variants

  def product_file=(product_file)
    parse_product_file(product_file)
    @preview_first = true
  end

  def stock_file=(stock_file)
    return parse_stock_file(stock_file)
    @preview_first = true
  end

  def imported_products
    @imported_products ||= []
  end

  def imported_variants # not needed?
    @imported_variants ||= []
  end

  private

  def preview_first
    return false
    @preview_first ||= false
  end

  def parse_stock_file(stock_file)
    # nothing yet
  end

  def parse_product_file(product_file)

    def erb_conversion(regex)  
      return regex.gsub(/\{[^}]+\}/) {|var| '<%= params["' + var.downcase.gsub(/\{|\}/,'') + '"] %>'}
    end

    def tidy(cell)
      cell ? cell.strip.gsub(/\s+/, ' ') : ''
    end

    def handlify(name)
      tidy name.downcase.gsub(' ', '-').gsub(/[^\w-]/, '').gsub(/-+/, '-').gsub(/^-|-$/, '')
    end

    defaults = {
      #'brand_name' => 'undefined',
      #'collection' => 'undefined',
      'title_template' => '<%=name%>'
    }
    option_kinds = []
    column_headings = []
    products = []
    variants = []

    CSV.parse(product_file.read) do |row|
      first_row = tidy(row[0]).upcase
      case first_row
      when 'DEF'
        case row[1].upcase
        when 'BRAND'
          defaults['brand'] = tidy(row[2])
        when 'COLLECTION'
          defaults['collection']  = tidy(row[2])
        when 'TITLE'
          defaults['title_template'] = erb_conversion(tidy(row[2]))
        when 'OPT'
          option_kind = tidy(row[2]).downcase
          option_kinds << option_kind
        end
      when 'COLS'
        1.upto(row.size) do |i|
          column = tidy(row[i]).downcase
          column_headings[i] = column
        end
      when 'ITEM'
        inventory = 0
        price = nil
        compare_at_price = nil
        trade_price = nil
        code = nil
        params = {
          'name' => 'undefined',
          'title_template' => defaults['title_template'],
          'brand' => defaults['brand'],
          'collection' => defaults['collection'],
        }

        column_headings.each_index do |i|
          next unless column_headings[i] and row[i]
          key = column_headings[i]
          value = tidy(row[i])
          case key
          when 'qty', 'quantity', 'stock', 'inventory'
            inventory = value
          when 'code'
            code = value
          when 'trade price', 'trade'
            trade_price = value
          when 'compare at price'
            compare_at_price = value
          else
            params[key] = value
          end
        end

        params['title'] = ERB.new(defaults['title_template']).result(binding)
        params['handle'] = handlify params['title']
        
        # IMPORTANT: Ignore columns with no ActiveRecord equivalent
        params.each_key do |param|
          unless Product.column_names.include?(param) ||
            option_kinds.include?(param) ||
            param == 'brand' || param == 'collection'
            params.delete(param)
          end
        end

        # add the tags
        #params['tags'] = "#{params['brand']}, #{params['collection']}, #{params['tags']}"

        # put all kinds of product option into an array of arrays
        options = option_kinds.map do |opt|
          params[opt].split(',') if params[opt] and not params[opt].empty?
        end.compact

        # remove options from params and create new option kind if required
        option_kinds.each do |opt|
          params.delete(opt)
          OptionKind.find_or_create_by_name(opt)
        end
        
        # turn brand and collection into activerecords
        params['brand'] = self.brands.find_or_create_by_name(params['brand'])
        params['collection']  = self.collections.find_or_create_by_name(params['collection'])
        params['company'] = self
        
        product = Product.find_or_create_by_handle(params)
        
        combinations = []
        case options.size
        when  0
          combinations = [[]] # creat a variant but with no variations
        when 1
          combinations = options
        else
          # output the cartesian project of each kind of option 
          # (flattening the resulting array elements)
          combinations = (options.inject() { |x,y| x.product y }).map { |a| a.flatten }
        end

        # create variants
        combinations.each do |combo|

          variant_params = {
            'product' => product,
            'sku' => product['handle'], 
            'code' => product['code'],
            'inventory' => inventory,
            'price' => price,
            'compare_at_price' => compare_at_price,
            'trade_price' => trade_price
          }
          combo.each_index do |i|
            variant_params['sku'] += "-#{handlify combo[i] }"
          end
          variant = Variant.find_or_create_by_sku(variant_params)
          combo.each_index do |i|
            option_params = {
              'variant' => variant,
              'option_kind' => OptionKind.find_by_name(option_kinds[i]),
              'value' => combo[i]
            }

            Option.find_or_create_by_variant_id_and_option_kind_id(option_params)
            
          end
        end

        imported_products << product

      end 
    end
  end

end
