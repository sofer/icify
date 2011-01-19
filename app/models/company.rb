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

  # not in use
  def var1=(var)
  end
  def var2=(var)
  end
  def var3=(var)
  end

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

  def imported_variants
    @imported_variants ||= []
  end

  private

  def preview_first
    return false
    @preview_first ||= false
  end

  def erb_conversion(regex)
    regex.gsub!(/\{[^}]+\}/) {|var| '<%='+var.downcase.gsub(/\{|\}/,'')+'%>'}
    regex.gsub!('<%=collection%>', '<%=collection.name%>' )
    regex.gsub!('<%=brand%>', '<%=brand.name%>' )
    return regex
  end

  def parse_stock_file(stock_file)
    # nothing yet
  end

  def new_parse_product_file(product_file)
      handle = handle_regex = title = title_regex = var1 = var2 = var3 = name = description = brand = collection = price = tags = ''
    CSV.parse(product_file.read) do |row|
      if row[0] == 'DEF'
        case row[1]
        when 'BRAND'
          brand_name = row[2].strip
          brand = self.brands.find_or_create_by_name(brand_name)
        when 'COLLECTION'
          collection_name = row[2].strip
          collection = self.collections.find_or_create_by_name(collection_name)
        when 'TITLE'
          title_regex = erb_conversion(row[2]).strip
        when 'HANDLE'
          handle_regex = erb_conversion(row[2]).strip
        when 'VAR1'
          var1 = row[2].strip
        when 'VAR2'
          var2 = row[2].strip
        when 'VAR3'
          var3 = row[2].strip
        end
      elsif row[0] == 'ITEM'
        name = row[2].strip
        price = row[3].strip
        description = row[4]
        tags = row[5]
        title = ERB.new(title_regex).result(binding).strip
        handle = ERB.new(handle_regex).result(binding).strip
        handle.downcase.gsub!(' ', '-')
        tags = "#{brand.name}, #{collection.name}, #{tags}"

        product =  self.products.find_or_initialize_by_handle(handle)
        product.title = title
        product.body = description
        product.brand = brand
        product.collection = collection
        product.tags = tags
        product.var1 = var1
        product.var2 = var2
        product.var3 = var3
        product.price = price
        imported_products << product
      end
    end
  end

  def parse_product_file(product_file)
      handle = handle_regex = title = title_regex = var1 = var2 = var3 = name = description = brand = collection = price = tags = ''
    CSV.parse(product_file.read) do |row|
      if row[0] == 'DEF'
        case row[1]
        when 'BRAND'
          brand_name = row[2].strip
          brand = self.brands.find_or_create_by_name(brand_name)
        when 'COLLECTION'
          collection_name = row[2].strip
          collection = self.collections.find_or_create_by_name(collection_name)
        when 'TITLE'
          title_regex = erb_conversion(row[2]).strip
        when 'HANDLE'
          handle_regex = erb_conversion(row[2]).strip
        when 'VAR1'
          var1 = row[2].strip
        when 'VAR2'
          var2 = row[2].strip
        when 'VAR3'
          var3 = row[2].strip
        end
      elsif row[0] == 'ITEM'
        name = row[2].strip
        price = row[3].strip
        description = row[4]
        tags = row[5]
        title = ERB.new(title_regex).result(binding).strip
        handle = ERB.new(handle_regex).result(binding).strip
        handle.downcase.gsub!(' ', '-')
        tags = "#{brand.name}, #{collection.name}, #{tags}"
        product =  Product.find_or_create_by_handle(
          :company => self,
          :handle => handle,
          :title => title,
          :body => description,
          :brand => brand,
          :collection => collection,
          :tags => tags
        )
        # price if no variants?
        imported_products << product
        if row[6] or row[6] == ''
          var1_arr = row[6].split(',')
          if not row[7] or row[7] == ''
            var1_arr.each do |var1|
              var1.strip!
              #logger.debug("var1: #{var1}")
              sku = "#{handle}-#{var1}"
              variant = Variant.find_or_create_by_sku(
                :product => product,
                :sku => sku,
                :product_handle => product.handle,
                :price => price
              )
              begin
                variant.save!
              rescue RecordInvalid => error
                # do something
              end
              imported_variants << variant
            end
          else
            var2_arr = row[7].split(',')
            var1_arr.each do |var1|
              var1.strip!
              var2_arr.each do |var2|
                var2.strip!
                sku = "#{handle}-#{var1}-#{var2}"
                variant = Variant.find_or_create_by_sku(
                  :product => product,
                  :sku => sku,
                  :product_id => product.id,
                  :price => price
                )
                begin
                  variant.save!
                rescue RecordInvalid => error
                  # do something
                end
                imported_variants << variant
              end
            end
          end
        end
      end
    end
  end

end
