class Brand < ActiveRecord::Base
  belongs_to :company
  has_many :products
  has_many :collections, :through => :products, :uniq => true
  def products_by_collection
    
  end

end
