module ProductsHelper
  def variant_text(variant)
    variant.product.title+ (variant.options.empty? ? variant.sku : 
      variant.options.inject(' -') { |txt,opt| txt+' '+opt.value })
  end
end
