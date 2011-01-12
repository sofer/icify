class CreateVariants < ActiveRecord::Migration
  def self.up
    create_table :variants do |t|
      t.integer :product_id,  :null => false
      t.string :sku,  :null => false
      t.integer :weight,  :null => false, :default => 0
      t.integer :inventory
      t.string :inventory_policy,  :null => false, :default => 'deny'
      t.string :fulfillment,  :null => false, :default => 'manual'
      t.decimal :price, :precision => 10, :scale => 2
      t.decimal :compare_at_price, :precision => 10, :scale => 2
      t.boolean :Shipping,  :null => false, :default => 'true'
      t.boolean :taxable,  :null => false, :default => 'false'

      t.timestamps
    end
  end

  def self.down
    drop_table :variants
  end
end
