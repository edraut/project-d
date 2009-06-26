class Product < ActiveRecord::Base
  attr_accessor :dirty_index
  include FormatsErrors
  has_many :category_products, :dependent => :destroy
  has_many :categories, :through => :category_products
  belongs_to :manufacturer
  has_many :product_images, :dependent => :destroy, :order => 'position'
  has_many :product_options, :dependent => :destroy, :order => 'position'
  has_many :order_items, :through => :product_options
  has_many :product_colors, :dependent => :destroy
  has_many :colors, :through => :product_colors
  has_many :product_sizes, :dependent => :destroy
  has_many :sizes, :through => :product_sizes
  has_one :product_vector, :dependent => :destroy
  composed_of :ground_price, :class_name => 'Money', :mapping => [%w(ground_price cents)]
  composed_of :second_day_price, :class_name => 'Money', :mapping => [%w(second_day_price cents)]
  composed_of :overnight_price, :class_name => 'Money', :mapping => [%w(overnight_price cents)]
  composed_of :international_price, :class_name => 'Money', :mapping => [%w(international_price cents)]
  named_scope :published, :conditions => {:state => 'published'}
  named_scope :featured, :conditions => {:featured => true}, :order => :featured_position
  named_scope :specials, :conditions => {:specials => true}, :order => :specials_position
  named_scope :clearance, :conditions => {:clearance => true}, :order => :clearance_position
  named_scope :whats_new, :conditions => {:whats_new => true}, :order => :whats_new_position
  named_scope :any, :conditions => ["1 = 1",nil]
  before_save :set_index_state
  after_save :update_vector_row
  
  state_machine :initial => :unpublished do
    before_transition :on => :unpublish, :do => :unfeature
    event :publish do
      transition :unpublished => :published
    end
    
    event :unpublish do
      transition :published => :unpublished
    end
    
    state :unpublished do
      validates_presence_of :name
      def validate
      end
      def next_action
        'publish'
      end
    end
    
    state :published do
      validates_presence_of :name
      def validate
        errors.add_to_base('You must add at least one product option before you can publish') unless product_options.any?
        errors.add_to_base('You must add at least one image before you can publish') unless product_images.any?
      end
      def next_action
        'unpublish'
      end
    end
  end
  
  def unfeature
    self.featured = false
    return true
  end
  
  def hit
    self.hit_count += 1
    self.save(false)
  end
  
  def set_index_state
    self.dirty_index = self.name_changed?
    return true
  end

  def to_param
    "#{id}-#{PermalinkFu.escape(name)}"
  end
    
  def update_vector_row
    if self.dirty_index
      self.product_vector ||= ProductVector.new(:product_id => self.id)
      ProductVector.update_vectors
    end
    return true
  end
end
