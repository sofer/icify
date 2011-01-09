class Company < ActiveRecord::Base
  has_many :brands
  has_many :collections
  has_many :products
end
