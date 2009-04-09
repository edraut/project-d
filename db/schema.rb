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

ActiveRecord::Schema.define(:version => 20090324133514) do

  create_table "products", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "manufacturer_id", :limit => 11
    t.integer  "category_id", :limit => 11
    t.boolean  "new", :default => true
    t.string   "state"
    t.integer  "ground_price"
    t.integer  "second_day_price"
    t.integer  "overnight_price"
    t.integer  "international_price"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "product_options", :force => true do |t|
    t.string   "name"
    t.integer  "product_id", :limit => 11
    t.integer  "price"
    t.string   "sku"
    t.integer  "inventory_quantity"
    t.integer  "position"
  end
  
  add_index "product_options", ["product_id"], :name => 'index_product_options_on_product_id'
  
  create_table "manufacturers", :force => true do |t|
    t.string   "name"
  end
  
  add_index "manufacturers", ["name"], :name => 'index_manufacturers_on_name'

  create_table "product_sizes", :force => true do |t|
    t.integer  "product_id", :limit => 11
    t.integer  "size_id", :limit => 11
    t.integer  "price"
    t.integer  "position"
  end
  
  add_index "product_sizes", ["product_id"], :name => "index_product_sizes_on_product_id"

  create_table "sizes", :force => true do |t|
    t.integer  "size_group_id", :limit => 11
    t.string   "name"
  end
  
  add_index "sizes", ["size_group_id"], :name => "index_sizes_on_size_group_id"
  
  create_table "size_groups", :force => true do |t|
    t.string   "name"
  end
  
  add_index "size_groups", ["name"], :name => "index_size_groups_on_name", :unique => true
  
  create_table "product_colors", :force => true do |t|
    t.integer  "product_id", :limit => 11
    t.integer  "color_id", :limit => 11
    t.integer  "position"
  end
  
  add_index "product_colors", ["product_id"], :name => "index_product_colors_on_product_id"

  create_table "colors", :force => true do |t|
    t.integer  "color_group_id", :limit => 11
    t.string   "name"
  end
  
  add_index "colors", ["color_group_id"], :name => "index_colors_on_color_group_id"
  
  create_table "color_groups", :force => true do |t|
    t.string   "name"
  end
  
  add_index "color_groups", ["name"], :name => "index_color_groups_on_name", :unique => true
  
  create_table "product_images", :force => true do |t|
    t.integer  "product_id", :limit => 11
    t.string   "caption"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_fize_size"
    t.datetime "image_updated_at"
    t.integer  "position"
  end
  
  add_index "product_images", ["product_id"], :name => "index_product_images_on_product_id"
  
  create_table "categories", :force => true do |t|
    t.string   "name"
    t.integer  "parent_id"
    t.integer  "position"
  end
  
  add_index "categories", ["name"], :name => 'index_categories_on_name'
  
  create_table "vehicle_makes", :force => true do |t|
    t.string   "name"
    t.integer  "position"
  end
  
  add_index "vehicle_makes", ["name"], :name => 'index_vehicle_makes_on_name'

  create_table "vehicle_models", :force => true do |t|
    t.string   "name"
    t.integer  "vehicle_make_id", :limit => 11
    t.integer  "vehicle_type_id", :limit => 11
    t.integer  "position"
  end
  
  add_index "vehicle_models", ["name"], :name => 'index_vehicle_models_on_name'
  add_index "vehicle_models", ["vehicle_make_id"], :name => 'index_vehicle_models_on_vehicle_make_id'
  add_index "vehicle_models", ["vehicle_type_id"], :name => 'index_vehicle_models_on_vehicle_type_id'

  create_table "vehicle_types", :force => true do |t|
    t.string "name"
    t.integer "position"
  end
  
  create_table "product_option_vehicle_makes", :force => true do |t|
    t.integer  "product_option_id", :limit => 11
    t.integer  "vehicle_make_id"
  end

  add_index "product_option_vehicle_makes", ["product_option_id"], :name => 'index_product_option_vehicle_makes_on_product_option_id'
  add_index "product_option_vehicle_makes", ["vehicle_make_id"], :name => 'index_product_option_vehicle_makes_on_vehicle_make_id'

  create_table "product_option_vehicle_models", :force => true do |t|
    t.integer  "product_option_id", :limit => 11
    t.integer  "vehicle_model_id"
    t.integer  "year_begin", :default => nil
    t.integer  "year_end", :default => nil
  end

  add_index "product_option_vehicle_models", ["product_option_id"], :name => 'index_product_option_vehicle_models_on_product_option_id'
  add_index "product_option_vehicle_models", ["vehicle_model_id"], :name => 'index_product_option_vehicle_models_on_vehicle_model_id'

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

end
