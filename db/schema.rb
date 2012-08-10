# encoding: UTF-8
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

ActiveRecord::Schema.define(:version => 20120810211004) do

  create_table "authentications", :force => true do |t|
    t.timestamp "created_at",   :null => false
    t.timestamp "updated_at",   :null => false
    t.integer   "user_id"
    t.string    "provider"
    t.string    "uid"
    t.string    "access_token"
    t.string    "nickname"
    t.string    "thumbnail"
  end

  create_table "friendly_id_slugs", :force => true do |t|
    t.string    "slug",                         :null => false
    t.integer   "sluggable_id",                 :null => false
    t.string    "sluggable_type", :limit => 40
    t.timestamp "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type"], :name => "index_friendly_id_slugs_on_slug_and_sluggable_type", :unique => true
  add_index "friendly_id_slugs", ["sluggable_id"], :name => "index_friendly_id_slugs_on_sluggable_id"
  add_index "friendly_id_slugs", ["sluggable_type"], :name => "index_friendly_id_slugs_on_sluggable_type"

  create_table "orders", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "store_id"
  end

  add_index "orders", ["store_id"], :name => "index_orders_on_store_id"

  create_table "product_images", :force => true do |t|
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.integer  "product_id"
    t.string   "instagram_id"
    t.string   "url"
    t.string   "tags"
    t.string   "thumbnail"
    t.integer  "likes"
  end

  add_index "product_images", ["product_id"], :name => "index_product_imagess_on_product_id"

  create_table "products", :force => true do |t|
    t.string   "name"
    t.text     "description",            :limit => 500
    t.string   "status"
    t.string   "colors"
    t.string   "sizes"
    t.string   "instagram_tag"
    t.string   "photos"
    t.decimal  "price"
    t.decimal  "flatrate_shipping_cost"
    t.integer  "quantity"
    t.integer  "store_id"
    t.string   "slug"
    t.boolean  "unlimited_quantity"
    t.datetime "updated_at",                            :null => false
    t.datetime "created_at",                            :null => false
  end

  add_index "products", ["slug"], :name => "index_products_on_slug"
  add_index "products", ["store_id"], :name => "index_products_on_store_id"

  create_table "stores", :force => true do |t|
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.string   "name"
    t.integer  "user_id"
    t.string   "slug"
    t.text     "return_policy", :limit => 500
  end

  add_index "stores", ["slug"], :name => "index_stores_on_slug"
  add_index "stores", ["user_id"], :name => "index_stores_on_user_id"

  create_table "users", :force => true do |t|
    t.timestamp "created_at",                             :null => false
    t.timestamp "updated_at",                             :null => false
    t.string    "email",                  :default => "", :null => false
    t.string    "encrypted_password",     :default => "", :null => false
    t.string    "reset_password_token"
    t.timestamp "reset_password_sent_at"
    t.timestamp "remember_created_at"
    t.integer   "sign_in_count",          :default => 0
    t.timestamp "current_sign_in_at"
    t.timestamp "last_sign_in_at"
    t.string    "current_sign_in_ip"
    t.string    "last_sign_in_ip"
    t.string    "first_name"
    t.string    "website"
    t.string    "last_name"
    t.string    "business_name"
    t.string    "street_address_1"
    t.string    "street_address_2"
    t.string    "city"
    t.string    "state"
    t.string    "postal_code"
    t.string    "phone_number"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
