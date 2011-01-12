require 'csv'
require 'erb'

class Import < ActiveRecord::Base
  
  belongs_to :company
  has_many :products
  has_many :variants, :through => :products

  validates_presence_of :items
  
  accepts_nested_attributes_for :products, :variants

  def csv_file=(csv_file)
    parse_csv(csv_file)
  end

  private
  
  def erb_conversion(regex)
    regex.gsub(/\{[^}]+\}/) {|var| '<%='+var.downcase.gsub(/\{|\}/,'')+'%>'}
  end

  def parse_csv(csv_file)

    handle = handle_regex = title = title_regex = var1 = var2 = var3 = name = description = brand = collection = price = tags = ''
    CSV.parse(csv_file.read) do |row|
      if row[0] == 'DEF'
        case row[1]
        when 'BRAND'
          brand = row[2].strip
        when 'COLLECTION'
          collection = row[2].strip
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
        tags = "#{brand}, #{collection}, #{tags}"
        product =  Product.new({
          :handle => handle,
          :title => title,
          :body => description
          #"brand" => brand,
          #"collection" => collection
          #"tags" => tags,
        })
        self.products << product
        if row[6] or row[6] == ''
          var1_arr = row[6].split(',')
          if not row[7] or row[7] == ''
            var1_arr.each do |variant|
              variant.strip!
              self.variants << Variant.new({
                :product_id => product.id,
                :sku => "#{handle}-#{variant}",
                :price => price
              })
            end
          else
            var2_arr = row[7].split(',')
            var1_arr.each do |var1|
              var1.strip!
              var2_arr.each do |var2|
                var2.strip!
                self.variants << Variant.new({
                  :product_id => product.id,
                  :sku => "#{handle}-#{var1}=#{var2}",
                  :price => price
                })
              end
            end
          end
        end
      end
    end
    return products, variants
  end
  
   
end
