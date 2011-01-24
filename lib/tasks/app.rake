namespace :app do

  task :ensure_development_environment => :environment do
    if Rails.env.production?
      raise "\nDon't drop the production database."
    end
  end

  desc "Reset"
  task :reset => [:ensure_development_environment, "db:drop", "db:create", "db:migrate", "db:seed", "app:populate"]

  desc "Populate the database with development data."
  task :populate => :environment do
    [
      #:brand_id => "1", :collection_id => "1", :handle => "test_snowboard", :title => "Test snowboard"
    ].each do |attributes|
      Company.first.products.create(attributes)
    end
  end
  
  desc "remove extraneous characters from models"
  task :tidy => :environment do
    Product.all.each do |product|
      product.handle.gsub!(/-+/, '-')
      puts product.handle
      product.save!
    end
    Variant.all.each do |variant|
      variant.sku.gsub!(/-+/, '-')
      puts variant.sku
      variant.save!
    end
  end

end
