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
  has_many :product_vehicle_makes, :dependent => :destroy
  has_many :product_vehicle_models, :dependent => :destroy
  has_many :vehicle_makes, :through => :product_vehicle_makes
  has_many :vehicle_models, :through => :product_vehicle_models

  state_machine :initial => :incomplete do
    event :add_info do
      transition :incomplete => :complete, :complete => same
    end
    
    state :incomplete do
      validates_presence_of :name
      def validate
      end
    end
    
    state :complete do
      def validate
        errors.add('category_id','You must select a category and subcategory for your product') unless category_id
      end
    end
  end
  
end
