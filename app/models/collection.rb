class Collection < ActiveRecord::Base
  belongs_to :company
  has_many :products
  has_many :brands, :through => :products, :uniq => :true
end
