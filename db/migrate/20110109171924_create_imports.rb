class CreateImports < ActiveRecord::Migration
  def self.up
    create_table :imports do |t|
      t.integer :company_id
      t.integer :items
      t.timestamps
    end
  end

  def self.down
    drop_table :imports
  end
end
