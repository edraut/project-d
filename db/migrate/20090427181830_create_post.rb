class CreatePost < ActiveRecord::Migration
  def self.up
    create_table :posts do |t|
      t.string    "title"
      t.text      "body"
      t.string    "image_file_name"
      t.string    "image_content_type"
      t.integer   "image_file_size"
      t.datetime  "image_updated_at"
      t.string    "postable_type"
      t.integer   "postable_id", :limit => 11
      t.integer   "position"
      t.datetime  "created_at"
      t.datetime  "updated_at"
    end
    
    add_index "posts", ["postable_type","postable_id"], :name => "index_posts_on_postable"
  end

  def self.down
    drop_table :posts
    remove_index "posts", "postable"
  end
end
