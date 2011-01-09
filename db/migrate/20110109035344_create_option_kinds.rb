class CreateOptionKinds < ActiveRecord::Migration
  def self.up
    create_table :option_kinds do |t|
      t.string :name,  :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :option_kinds
  end
end
