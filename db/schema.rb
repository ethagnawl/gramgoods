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

ActiveRecord::Schema.define(:version => 20130329213130) do

  create_table "authentications", :force => true do |t|
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.string   "access_token"
    t.string   "nickname"
    t.string   "thumbnail"
  end

  create_table "colors", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "product_id"
    t.string   "color"
  end

  add_index "colors", ["product_id"], :name => "index_colors_on_product_id"

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "friendly_id_slugs", :force => true do |t|
    t.string   "slug",                         :null => false
    t.integer  "sluggable_id",                 :null => false
    t.string   "sluggable_type", :limit => 40
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type"], :name => "index_friendly_id_slugs_on_slug_and_sluggable_type", :unique => true
  add_index "friendly_id_slugs", ["sluggable_id"], :name => "index_friendly_id_slugs_on_sluggable_id"
  add_index "friendly_id_slugs", ["sluggable_type"], :name => "index_friendly_id_slugs_on_sluggable_type"

  create_table "instagram_product_images", :force => true do |t|
    t.integer  "product_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "url"
  end

  create_table "line_items", :force => true do |t|
    t.datetime "created_at",                                                          :null => false
    t.datetime "updated_at",                                                          :null => false
    t.integer  "order_id"
    t.integer  "product_id"
    t.integer  "quantity"
    t.string   "size"
    t.string   "color"
    t.decimal  "price",                                :precision => 10, :scale => 2
    t.decimal  "total"
    t.decimal  "flatrate_shipping_option_cost",        :precision => 10, :scale => 2
    t.string   "product_name"
    t.decimal  "international_flatrate_shipping_cost", :precision => 10, :scale => 2
    t.string   "flatrate_shipping_option"
  end

  add_index "line_items", ["order_id"], :name => "index_line_items_on_order_id"
  add_index "line_items", ["product_id"], :name => "index_line_items_on_product_id"

  create_table "orders", :force => true do |t|
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.integer  "store_id"
    t.string   "status",     :default => "pending"
    t.string   "access_key"
  end

  add_index "orders", ["store_id"], :name => "index_orders_on_store_id"

  create_table "products", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "status"
    t.decimal  "price",                                :precision => 10, :scale => 2
    t.decimal  "domestic_flatrate_shipping_cost",      :precision => 10, :scale => 2
    t.integer  "quantity"
    t.integer  "store_id"
    t.string   "slug"
    t.boolean  "unlimited_quantity"
    t.datetime "updated_at",                                                                                 :null => false
    t.datetime "created_at",                                                                                 :null => false
    t.decimal  "international_flatrate_shipping_cost", :precision => 10, :scale => 2
    t.string   "purchase_type",                                                       :default => "buy-now"
    t.boolean  "external",                                                            :default => false
    t.string   "external_url"
    t.integer  "external_clickthroughs",                                              :default => 0
  end

  add_index "products", ["slug"], :name => "index_products_on_slug"
  add_index "products", ["store_id"], :name => "index_products_on_store_id"

  create_table "recipients", :force => true do |t|
    t.datetime "created_at",                                      :null => false
    t.datetime "updated_at",                                      :null => false
    t.integer  "order_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email_address"
    t.string   "street_address_one"
    t.string   "street_address_two"
    t.string   "city"
    t.string   "state"
    t.string   "postal_code"
    t.string   "country",            :default => "United States"
  end

  add_index "recipients", ["order_id"], :name => "index_recipients_on_order_id"

  create_table "sizes", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "product_id"
    t.string   "size"
  end

  add_index "sizes", ["product_id"], :name => "index_sizes_on_product_id"

  create_table "stores", :force => true do |t|
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "name"
    t.integer  "user_id"
    t.string   "slug"
    t.text     "return_policy"
  end

  add_index "stores", ["slug"], :name => "index_stores_on_slug"
  add_index "stores", ["user_id"], :name => "index_stores_on_user_id"

  create_table "user_product_images", :force => true do |t|
    t.integer  "product_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
  end

  create_table "users", :force => true do |t|
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "first_name"
    t.string   "website"
    t.string   "last_name"
    t.string   "business_name"
    t.string   "street_address_1"
    t.string   "street_address_2"
    t.string   "city"
    t.string   "state"
    t.string   "postal_code"
    t.string   "phone_number"
    t.boolean  "tos"
    t.string   "provider"
    t.string   "uid"
    t.string   "username"
    t.string   "thumbnail"
    t.string   "access_token"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
