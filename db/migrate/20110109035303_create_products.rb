class CreateProducts < ActiveRecord::Migration
  def self.up
    create_table :products do |t|
      t.integer :company_id,  :null => false
      t.integer :brand_id,  :null => false
      t.integer :collection_id,  :null => false
      t.string :handle,  :null => false
      t.string :title,  :null => false
      t.string :body,  :null => false, :default => 'no description yet'

      t.timestamps
    end
  end

  def self.down
    drop_table :products
  end
end
