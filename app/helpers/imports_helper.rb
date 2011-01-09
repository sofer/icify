require 'erb'
require 'csv'

module ImportsHelper

  def csv_display(csv_file)

    output = "Handle,Title,Body (HTML),Vendor,Type,Tags,Option1 Name,Option1 Value,Option2 Name,Option2 Value,Option3 Name,Option3 Value,Variant SKU,Variant Grams,Variant Inventory Tracker,Variant Inventory Qty,Variant Inventory Policy,Variant Fulfillment Service,Variant Price,Variant Compare At Price,Variant Requires Shipping,Variant Taxable,Image Src\n"

    handle = handle_regex = title = title_regex = var1 = var2 = var3 = name = description = brand = collection = price = tags = ''

    def erb_conversion(regex)
      regex.gsub(/\{[^}]+\}/) {|var| '<%='+var.downcase.gsub(/\{|\}/,'')+'%>'}
    end  

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
        if not row[6] or row[6] == '' # no variants
          title = ERB.new(title_regex).result().strip
          handle = ERB.new(handle_regex).result().strip
          handle.downcase.gsub!(' ', '-')
          output += %Q|#{handle},#{title},"#{description}",#{brand},#{collection},"#{brand}, #{collection}, #{tags}",Title,Default,,,,,,0,"",1,deny,manual,#{price},,true,false,\n|
        elsif 1 #not row[7] or row[7] == ''
          var1_arr = row[6].split(',')
          var1_arr.each do |variant|
            variant.strip!
            title = ERB.new(title_regex).result(binding).strip
            handle = ERB.new(handle_regex).result(binding).strip
            handle.downcase!.gsub!(' ', '-')
            output += %Q|#{handle},#{title},"#{description}",#{brand},#{collection},"#{brand}, #{collection}, #{variant}, #{tags}",#{var1},#{variant},,,,,#{handle}-#{variant},0,"",1,deny,manual,#{price},,true,false,\n|
          end
        else
          var2_arr = row[7].split(',')
          # 2 kinds of variant
        end
      end
    end
    return output
  end

end

