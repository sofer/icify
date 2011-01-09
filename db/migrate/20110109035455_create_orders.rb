class CreateOrders < ActiveRecord::Migration
  def self.up
    create_table :orders do |t|
      t.integer :company_id,  :null => false
      t.datetime :date,  :null => false
      t.string :description
      t.string :kind,  :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :orders
  end
end
