class Product < ActiveRecord::Base
  belongs_to :company
  has_many :variants
  belongs_to :brand
  belongs_to :collection
end
