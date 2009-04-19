class Order < ActiveRecord::Base
  SHIPPING_METHODS = ['Ground','2nd Day','Overnight','International'].freeze
  include FormatsErrors
  belongs_to :user
  has_many :order_items
  has_one :billing_address, :dependent => :destroy
  has_one :shipping_address, :dependent => :destroy
  has_many :addresses, :dependent => :destroy
  before_save :update_shipping
  before_save :update_subtotal
  composed_of :shipping_total, :class_name => 'Money', :mapping => [%w(shipping_total cents)]
  composed_of :subtotal, :class_name => 'Money', :mapping => [%w(subtotal cents)]
  named_scope :carts, :condtions => {:state => 'cart'}
  named_scope :orders, :conditions => ["state != 'cart'",nil]
  named_scope :pending, :conditions => {:state => 'pending'}
  named_scope :fulfilled, :conditions => {:state => 'fulfilled'}
  named_scope :rejected, :conditions => {:state => 'card_rejected'}
  
  state_machine :initial => :cart do
    event :accept_card do
      transition [:cart, :card_rejected] => :pending
    end
    event :reject_card do
      transition :cart => :card_rejected
    end
    event :fulfill do
      transition :pending => :fulfilled
    end
    state :cart do
    end
    state :card_rejected do
    end
    state :pending do
    end
    state :fulfilled do
    end
  end
  
  def ready_to_charge?
    if self.order_items.any? and self.billing_address and self.shipping_address and (self.billing_address.status == 'live') and (self.shipping_address.status == 'live')
      return true
    else
      return false
    end
  end

  def shipping_method_price_col
    case shipping_method
    when 'Ground'
      'ground_price'
    when '2nd Day'
      'second_day_price'
    when 'Overnight'
      'overnight_price'
    when 'International'
      'international_price'
    end
  end
  
  def update_shipping
    if !self.shipping_method.blank? and self.order_items.any?
      self.shipping_total = Money.new(self.calculate_shipping.to_f)
    else
      self.shipping_total = Money.new(0)
    end
  end
  
  def update_subtotal
    if self.order_items.any?
      self.subtotal = Money.new(self.calculate_subtotal.to_f)
    else
      self.subtotal = Money.new(0)
    end
  end
  
  def total
    self.shipping_total + self.subtotal
  end
  
  def calculate_shipping
    self.order_items.sum("order_items.quantity * products.#{shipping_method_price_col}", :joins => {:product_option => :product})
  end
  
  def calculate_subtotal
    self.order_items.sum("price * quantity")
  end
  CARD_MONTHS = ['01','02','03','04','05','06','07','08','09','10','11','12'].freeze
  CARD_YEARS = Array.new(8) {|i| (i + Date.today.year).to_s}
end
