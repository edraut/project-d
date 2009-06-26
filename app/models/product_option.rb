class ProductOption < ActiveRecord::Base
  include FormatsErrors
  belongs_to :product
  composed_of :price, :class_name => 'Money', :mapping => [%w(price cents)]
  has_many :product_option_vehicle_makes, :dependent => :destroy
  has_many :product_option_vehicle_models, :dependent => :destroy
  has_many :vehicle_makes, :through => :product_option_vehicle_makes
  has_many :vehicle_models, :through => :product_option_vehicle_models
  has_many :order_items
  named_scope :in_stock, :conditions => ["(inventory_quantity is null or inventory_quantity > 0)"]
  
end