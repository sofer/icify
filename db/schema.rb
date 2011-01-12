# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110109171924) do

  create_table "assets", :force => true do |t|
    t.string   "source",     :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "brands", :force => true do |t|
    t.integer  "company_id", :null => false
    t.string   "name",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "collections", :force => true do |t|
    t.integer  "company_id", :null => false
    t.string   "name",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "companies", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "images", :force => true do |t|
    t.integer  "product_id"
    t.integer  "variant_id"
    t.integer  "asset_id",   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "imports", :force => true do |t|
    t.integer  "company_id"
    t.integer  "items"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "items", :force => true do |t|
    t.integer  "variant_id", :null => false
    t.integer  "quantity",   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "option_kinds", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "options", :force => true do |t|
    t.integer  "option_kind_id", :null => false
    t.integer  "variant_id",     :null => false
    t.string   "value",          :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "orders", :force => true do |t|
    t.integer  "company_id",  :null => false
    t.datetime "date",        :null => false
    t.string   "description"
    t.string   "kind",        :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "products", :force => true do |t|
    t.integer  "company_id",                                      :null => false
    t.integer  "brand_id",                                        :null => false
    t.integer  "collection_id",                                   :null => false
    t.string   "handle",                                          :null => false
    t.string   "title",                                           :null => false
    t.string   "body",          :default => "no description yet", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tags", :force => true do |t|
    t.integer  "product_id", :null => false
    t.string   "value",      :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "variants", :force => true do |t|
    t.integer  "product_id",                                                            :null => false
    t.string   "sku",                                                                   :null => false
    t.integer  "weight",                                          :default => 0,        :null => false
    t.integer  "inventory"
    t.string   "inventory_policy",                                :default => "deny",   :null => false
    t.string   "fulfillment",                                     :default => "manual", :null => false
    t.decimal  "price",            :precision => 10, :scale => 2
    t.decimal  "compare_at_price", :precision => 10, :scale => 2
    t.boolean  "Shipping",                                        :default => true,     :null => false
    t.boolean  "taxable",                                         :default => false,    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
