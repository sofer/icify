class CreateVariants < ActiveRecord::Migration
  def self.up
    create_table :variants do |t|
      t.integer :product_id,  :null => false
      t.string :SKU,  :null => false
      t.integer :weight,  :null => false, :default => 0
      t.integer :inventory
      t.string :Inventory_Policy,  :null => false, :default => 'deny'
      t.string :fulfillment,  :null => false, :default => 'manual'
      t.decimal :Price, :precision => 10, :scale => 2
      t.decimal :Compare_At_Price, :precision => 10, :scale => 2
      t.boolean :Shipping,  :null => false, :default => 'true'
      t.boolean :Taxable,  :null => false, :default => 'false'

      t.timestamps
    end
  end

  def self.down
    drop_table :variants
  end
end
