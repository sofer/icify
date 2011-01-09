class CreateBrands < ActiveRecord::Migration
  def self.up
    create_table :brands do |t|
      t.integer :company_id,  :null => false
      t.string :name,  :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :brands
  end
end
