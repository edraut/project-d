class Coupon < ActiveRecord::Base
  include FormatsErrors
  has_many :orders
  composed_of :flat_amount, :class_name => 'Money', :mapping => [%w(flat_amount cents)]
  
  def useable?
    active and !(single_use and order_ids.any?)
  end
  
end