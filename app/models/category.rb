class Category < ActiveRecord::Base
  include FormatsErrors
  has_many :products
  belongs_to :parent, :foreign_key => "parent_id", :class_name => 'Category'
  has_many :children, :foreign_key => "parent_id", :class_name => 'Category'
  named_scope :top_level, :conditions => {:parent_id => nil}, :order => 'position'

end