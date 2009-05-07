class AddFlagsToProduct < ActiveRecord::Migration
  def self.up
    add_column :products, :clearance, :boolean
    add_column :products, :whats_new, :boolean
    add_column :products, :featured_position, :integer
    add_column :products, :clearance_position, :integer
    add_column :products, :whats_new_position, :integer
  end

  def self.down
    remove_column :products, :whats_new_position
    remove_column :products, :clearance_position
    remove_column :products, :featured_position
    remove_column :products, :whats_new
    remove_column :products, :clearance
  end
end
