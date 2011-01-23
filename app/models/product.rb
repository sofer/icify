class Product < ActiveRecord::Base
  belongs_to :company
  has_many :variants
  belongs_to :brand
  belongs_to :collection
  
  def inventory
    variants.inject(0) { |sum,x| x.inventory ? sum + x.inventory : sum }
  end
  
end
