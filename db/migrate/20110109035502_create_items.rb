class CreateItems < ActiveRecord::Migration
  def self.up
    create_table :items do |t|
      t.integer :variant_id,  :null => false
      t.integer :quantity,  :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :items
  end
end
