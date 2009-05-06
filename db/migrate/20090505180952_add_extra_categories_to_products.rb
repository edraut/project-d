class AddExtraCategoriesToProducts < ActiveRecord::Migration
  def self.up
    create_table :category_products, :force => true do |t|
      t.integer :category_id, :limit => 11
      t.integer :product_id, :limit => 11
    end
    CategoryProduct.reset_column_information
    Product.all.each do |product|
      CategoryProduct.create(:product_id => product.id, :category_id => product.category_id)
    end
  end

  def self.down
    drop_table :category_products
  end
end
