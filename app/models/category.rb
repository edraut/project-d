class Category < ActiveRecord::Base
  include FormatsErrors
  has_many :products
  belongs_to :parent, :foreign_key => "parent_id", :class_name => 'Category'
  has_many :children, :foreign_key => "parent_id", :class_name => 'Category', :order => 'position'
  named_scope :top_level, :conditions => {:parent_id => nil}, :order => 'position'
  validates_uniqueness_of :name, :scope => :parent_id
  after_save :update_vector_row

  def update_vector_row
    ProductVector.update_vectors
  end
end