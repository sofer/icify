class CreateCollections < ActiveRecord::Migration
  def self.up
    create_table :collections do |t|
      t.integer :company_id,  :null => false
      t.string :name,  :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :collections
  end
end
