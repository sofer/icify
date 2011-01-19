class Variant < ActiveRecord::Base
  belongs_to :product
  
  def product_handle=(product_handle)
  end
  
end
