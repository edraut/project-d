class CreateSpecificPages < ActiveRecord::Migration
  def self.up
    Page.reset_column_information
    Page.create(:name => 'Home')
    Page.create(:name => 'About Us')
    Page.create(:name => 'News')
  end

  def self.down
  end
end
