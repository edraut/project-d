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
  
  def full_name
    temp_name = product_option.product.name
    if product_option_vehicle_model
      temp_name += " #{product_option_vehicle_model.vehicle_model.name} #{product_option_vehicle_model.year_begin} - #{product_option_vehicle_model.year_end}"
    elsif !product_option.name.blank? 
      temp_name += product_option.name 
    end 
    return temp_name
	end
  
end