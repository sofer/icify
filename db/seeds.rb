# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

company = Company.find_or_create_by_name({:name => "noble"})

[ "snowboards", "snowboard boots", "snowboard bindings" ].each do |name|
  company.collections.find_or_create_by_name(name)
end

[ "Endeavor", "Ftwo" ].each do |name|
  company.brands.find_or_create_by_name(name)
end

