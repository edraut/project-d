class OrderItem < ActiveRecord::Base
  include FormatsErrors
  belongs_to :order
  belongs_to :product_option
  belongs_to :product_option_vehicle_model
  composed_of :price, :class_name => 'Money', :mapping => [%w(price cents)]
  after_save :refresh_order_totals
  
  def total
    self.price * self.quantity
  end
  
  def refresh_order_totals
    self.order.update_subtotal
    self.order.update_shipping
    self.order.save
  end
end