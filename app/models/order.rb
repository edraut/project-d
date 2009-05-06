class Order < ActiveRecord::Base
<<<<<<< HEAD:app/models/order.rb
  SHIPPING_METHODS = ['Ground','2nd Day','Overnight','International'].freeze
  SHIPPING_RATES = {
    'Ground' =>         [Money.new(795),  Money.new(995),  Money.new(1495)],
    '2nd Day' =>        [Money.new(2500), Money.new(3000),  Money.new(4000)],
    'Overnight' =>      [Money.new(5000), Money.new(5500),  Money.new(6500)],
    'International' =>  [Money.new(5000), Money.new(5500),  Money.new(6500)]
  }.freeze
  SHIPPING_RANGES = [
    [Money.new(0),Money.new(9999)],
    [Money.new(10000),Money.new(19999)],
    [Money.new(20000),Money.new(29999)]
  ].freeze
=======
>>>>>>> multicategory:app/models/order.rb
  include FormatsErrors
  belongs_to :user
  has_many :order_items, :dependent => :destroy
  has_many :product_options, :through => :order_items
  has_one :billing_address, :dependent => :destroy
  has_one :shipping_address, :dependent => :destroy
  has_many :addresses, :dependent => :destroy
  before_save :update_subtotal
  before_save :update_shipping
  before_save :update_sales_tax
  composed_of :shipping_total, :class_name => 'Money', :mapping => [%w(shipping_total cents)]
  composed_of :subtotal, :class_name => 'Money', :mapping => [%w(subtotal cents)]
  composed_of :sales_tax, :class_name => 'Money', :mapping => [%w(sales_tax cents)]
  named_scope :carts, :conditions => {:state => 'cart'}
  named_scope :orders, :conditions => ["state != 'cart'",nil]
  named_scope :pending, :conditions => {:state => 'pending'}
  named_scope :fulfilled, :conditions => {:state => 'fulfilled'}
  named_scope :card_rejected, :conditions => {:state => 'card_rejected'}
  
  state_machine :initial => :cart do
    after_transition :on => :fulfill, :do => :set_shipping_date
    before_transition :on => :accept_card, :do => :update_inventory
    
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
      def ordered?
        false
      end
      def shipped?
        false
      end
    end
    state :card_rejected do
      def ordered?
        false
      end
      def shipped?
        false
      end
    end
    state :pending do
      def ordered?
       true
      end
      def shipped?
        false
      end
    end
    state :fulfilled do
      def ordered?
        true
      end
      def shipped?
        true
      end
    end
  end
  
  def set_shipping_date
    self.shipped_at = Time.now
    self.save(false)
  end
  
  def update_inventory
    self.order_items.each do |order_item|
      product_option = order_item.product_option
<<<<<<< HEAD:app/models/order.rb
      if product_option.inventory_quantity > 0
=======
      if product_option.inventory_quantity != nil and product_option.inventory_quantity > 0
>>>>>>> multicategory:app/models/order.rb
        product_option.inventory_quantity -= order_item.quantity
        product_option.save
      end
    end
    return true
  end
  
  def ready_to_charge?
    if self.order_items.any? and self.billing_address and self.shipping_address and (self.billing_address.status == 'live') and (self.shipping_address.status == 'live') and !self.email.blank?
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
  
  def taxable?
    self.shipping_address and self.shipping_address.state == 'ME'
  end
  
  def update_shipping
    if !self.shipping_method.blank? and self.order_items.any?
      self.shipping_total = self.calculate_shipping
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
  
  def update_sales_tax
    if self.taxable?
      self.sales_tax = self.calculate_sales_tax
    else
      self.sales_tax = Money.new(0)
    end
  end
  
  def total
    self.shipping_total + self.subtotal + (self.taxable? ? self.sales_tax : Money.new(0))
  end
  
  def calculate_shipping
    this_range_index = SHIPPING_RANGES.index SHIPPING_RANGES.find{|range| range.first <= self.subtotal and self.subtotal <= range.last}
    this_rate = SHIPPING_RATES[self.shipping_method][this_range_index]
  end
  
  def calculate_subtotal
    self.order_items.sum("price * quantity")
  end
  
  def calculate_sales_tax
    self.subtotal * 0.05
  end
  
  CARD_MONTHS = ['01','02','03','04','05','06','07','08','09','10','11','12'].freeze
  CARD_YEARS = Array.new(8) {|i| (i + Date.today.year).to_s}
  SHIPPING_METHODS = ['Ground','2nd Day','Overnight'].freeze
end
