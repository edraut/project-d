class ProductOption < ActiveRecord::Base
  include FormatsErrors
  belongs_to :product
  composed_of :price, :class_name => 'Money', :mapping => [%w(price cents)]
  
end