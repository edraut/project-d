class Product < ActiveRecord::Base
  include FormatsErrors
  belongs_to :category
  belongs_to :manufacturer
  has_many :product_images, :dependent => :destroy, :order => 'position'
  has_many :product_options, :dependent => :destroy, :order => 'position'
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
  named_scope :featured, :conditions => {:featured => true}
  named_scope :any, :conditions => ["1 = 1",nil]
  after_save :update_vector_row
  
  state_machine :initial => :unpublished do
    event :publish do
      transition :unpublished => :published
    end
    
    event :unpublish do
      transition :published => :unpublished
    end
    
    state :unpublished do
      validates_presence_of :name
      def validate
        errors.add('category_id','You must select a category and subcategory for your product') unless category_id
      end
      def next_action
        'publish'
      end
    end
    
    state :published do
      validates_presence_of :name
      def validate
        errors.add('category_id','You must select a category and subcategory for your product') unless category_id
        errors.add_to_base('You must add at least one product option before you can publish') unless product_options.any?
        errors.add_to_base('You must add at least one image before you can publish') unless product_images.any?
      end
      def next_action
        'unpublish'
      end
    end
  end
  
  def hit
    self.hit_count += 1
    self.save(false)
  end
  
  def update_vector_row
    self.product_vector ||= ProductVector.new(:product_id => self.id)
    ProductVector.update_vectors
  end
end
