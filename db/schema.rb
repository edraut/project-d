# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090626154128) do

  create_table "addresses", :force => true do |t|
    t.string   "type"
    t.string   "status"
    t.integer  "user_id"
    t.integer  "order_id"
    t.string   "first_name",                   :default => "", :null => false
    t.string   "last_name",                    :default => "", :null => false
    t.string   "middle_initial", :limit => 5,  :default => "", :null => false
    t.string   "address_1",                    :default => "", :null => false
    t.string   "address_2",                    :default => "", :null => false
    t.string   "city",                         :default => "", :null => false
    t.string   "state",                        :default => "", :null => false
    t.string   "zipcode",        :limit => 10, :default => "", :null => false
    t.string   "phone",          :limit => 20, :default => "", :null => false
    t.integer  "country_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "addresses", ["created_at"], :name => "index_addresses_on_created_at"
  add_index "addresses", ["order_id"], :name => "index_addresses_on_order_id"
  add_index "addresses", ["user_id"], :name => "index_addresses_on_user_id"

  create_table "categories", :force => true do |t|
    t.string  "name"
    t.integer "parent_id"
    t.integer "position"
    t.boolean "vehicle_filter", :default => false
    t.text    "vectors"
  end

  add_index "categories", ["name"], :name => "index_categories_on_name"
  add_index "categories", ["vectors"], :name => "categories_fts_vectors_index"

  create_table "category_products", :force => true do |t|
    t.integer "category_id"
    t.integer "product_id"
  end

  create_table "color_groups", :force => true do |t|
    t.string "name"
  end

  add_index "color_groups", ["name"], :name => "index_color_groups_on_name", :unique => true

  create_table "colors", :force => true do |t|
    t.integer "color_group_id"
    t.string  "name"
  end

  add_index "colors", ["color_group_id"], :name => "index_colors_on_color_group_id"

  create_table "countries", :force => true do |t|
    t.string   "iso"
    t.string   "name"
    t.string   "printable_name"
    t.string   "iso3"
    t.integer  "numcode"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "manufacturers", :force => true do |t|
    t.string "name"
  end

  add_index "manufacturers", ["name"], :name => "index_manufacturers_on_name"

  create_table "order_items", :force => true do |t|
    t.integer "order_id"
    t.integer "product_option_id"
    t.integer "product_option_vehicle_model_id"
    t.string  "sku"
    t.integer "price"
    t.integer "quantity"
  end

  add_index "order_items", ["order_id"], :name => "index_order_items_on_order_id"
  add_index "order_items", ["product_option_id"], :name => "index_order_items_on_product_option_id"

  create_table "orders", :force => true do |t|
    t.integer  "user_id"
    t.string   "email"
    t.string   "shipping_method"
    t.string   "state"
    t.string   "gateway_status_code"
    t.string   "gateway_status_message"
    t.integer  "shipping_total"
    t.integer  "subtotal"
    t.integer  "sales_tax"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "shipped_at"
    t.string   "paypal_transactionid"
    t.string   "paypal_paymentstatus"
  end

  add_index "orders", ["state"], :name => "index_orders_on_state"
  add_index "orders", ["user_id"], :name => "index_orders_on_user_id"

  create_table "pages", :force => true do |t|
    t.string "name"
  end

  create_table "posts", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "postable_type"
    t.integer  "postable_id"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "published",          :default => false
  end

  add_index "posts", ["postable_type", "postable_id"], :name => "index_posts_on_postable"

  create_table "product_colors", :force => true do |t|
    t.integer "product_id"
    t.integer "color_id"
    t.integer "position"
  end

  add_index "product_colors", ["product_id"], :name => "index_product_colors_on_product_id"

  create_table "product_images", :force => true do |t|
    t.integer  "product_id"
    t.string   "caption"
    t.string   "image_remote_url"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_fize_size"
    t.datetime "image_updated_at"
    t.integer  "position",           :default => 0
  end

  add_index "product_images", ["product_id"], :name => "index_product_images_on_product_id"

  create_table "product_option_vehicle_makes", :force => true do |t|
    t.integer "product_option_id"
    t.integer "vehicle_make_id"
  end

  add_index "product_option_vehicle_makes", ["product_option_id"], :name => "index_product_option_vehicle_makes_on_product_option_id"
  add_index "product_option_vehicle_makes", ["vehicle_make_id"], :name => "index_product_option_vehicle_makes_on_vehicle_make_id"

  create_table "product_option_vehicle_models", :force => true do |t|
    t.integer "product_option_id"
    t.integer "vehicle_model_id"
    t.integer "year_begin"
    t.integer "year_end"
  end

  add_index "product_option_vehicle_models", ["product_option_id"], :name => "index_product_option_vehicle_models_on_product_option_id"
  add_index "product_option_vehicle_models", ["vehicle_model_id"], :name => "index_product_option_vehicle_models_on_vehicle_model_id"

  create_table "product_options", :force => true do |t|
    t.string  "name"
    t.integer "product_id"
    t.integer "price"
    t.string  "sku"
    t.integer "inventory_quantity"
    t.integer "position"
  end

  add_index "product_options", ["product_id"], :name => "index_product_options_on_product_id"

  create_table "product_sizes", :force => true do |t|
    t.integer "product_id"
    t.integer "size_id"
    t.integer "price"
    t.integer "position"
  end

  add_index "product_sizes", ["product_id"], :name => "index_product_sizes_on_product_id"

  create_table "product_vectors", :force => true do |t|
    t.integer "product_id"
    t.text    "vectors"
  end

  add_index "product_vectors", ["vectors"], :name => "product_vectors_fts_vectors_index"

  create_table "products", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "manufacturer_id"
    t.integer  "category_id"
    t.boolean  "new",                 :default => true
    t.string   "state"
    t.boolean  "featured",            :default => false
    t.integer  "hit_count",           :default => 0
    t.integer  "ground_price"
    t.integer  "second_day_price"
    t.integer  "overnight_price"
    t.integer  "international_price"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "clearance"
    t.boolean  "whats_new"
    t.integer  "featured_position"
    t.integer  "clearance_position"
    t.integer  "whats_new_position"
    t.boolean  "specials"
    t.integer  "specials_position"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "size_groups", :force => true do |t|
    t.string "name"
  end

  add_index "size_groups", ["name"], :name => "index_size_groups_on_name", :unique => true

  create_table "sizes", :force => true do |t|
    t.integer "size_group_id"
    t.string  "name"
  end

  add_index "sizes", ["size_group_id"], :name => "index_sizes_on_size_group_id"

  create_table "users", :force => true do |t|
    t.string   "login",                     :limit => 40
    t.string   "name",                      :limit => 100, :default => ""
    t.string   "email",                     :limit => 100
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token",            :limit => 40
    t.datetime "remember_token_expires_at"
    t.string   "activation_code",           :limit => 40
    t.datetime "activated_at"
  end

  add_index "users", ["login"], :name => "index_users_on_login", :unique => true

  create_table "vehicle_makes", :force => true do |t|
    t.string  "name"
    t.integer "position"
  end

  add_index "vehicle_makes", ["name"], :name => "index_vehicle_makes_on_name"

  create_table "vehicle_models", :force => true do |t|
    t.string  "name"
    t.integer "vehicle_make_id"
    t.integer "vehicle_type_id"
    t.integer "position"
    t.text    "vectors"
  end

  add_index "vehicle_models", ["name"], :name => "index_vehicle_models_on_name"
  add_index "vehicle_models", ["vectors"], :name => "vehicle_models_fts_vectors_index"
  add_index "vehicle_models", ["vehicle_make_id"], :name => "index_vehicle_models_on_vehicle_make_id"
  add_index "vehicle_models", ["vehicle_type_id"], :name => "index_vehicle_models_on_vehicle_type_id"

  create_table "vehicle_types", :force => true do |t|
    t.string  "name"
    t.integer "position"
  end

end
