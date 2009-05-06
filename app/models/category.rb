class Category < ActiveRecord::Base
  include FormatsErrors
  has_many :category_products, :dependent => :destroy
  has_many :products, :through => :category_products
  belongs_to :parent, :foreign_key => "parent_id", :class_name => 'Category'
  has_many :children, :foreign_key => "parent_id", :class_name => 'Category', :order => 'position'
  named_scope :top_level, :conditions => {:parent_id => nil}, :order => 'position'
  validates_uniqueness_of :name, :scope => :parent_id
  after_save :update_tsearch_vectors

  acts_as_tsearch :fields => ["name"]

  def update_tsearch_vectors
    self.class.update_vectors
  end

end