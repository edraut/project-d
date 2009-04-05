class ProductSize < ActiveRecord::Base
  include FormatsErrors
  belongs_to :product
  belongs_to :size
  composed_of :price, :class_name => 'Money', :mapping => [%w(price cents)]
end