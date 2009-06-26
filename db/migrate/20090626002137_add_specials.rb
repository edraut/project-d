class AddSpecials < ActiveRecord::Migration
  def self.up
    add_column :products, :specials, :boolean
    add_column :products, :specials_position, :integer
  end

  def self.down
    remove_column :products, :specials_position
    remove_column :products, :specials
  end
end
