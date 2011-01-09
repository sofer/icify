class CreateOptions < ActiveRecord::Migration
  def self.up
    create_table :options do |t|
      t.integer :option_kind_id,  :null => false
      t.integer :variant_id,  :null => false
      t.string :value,  :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :options
  end
end
