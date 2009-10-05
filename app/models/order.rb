class Order < ActiveRecord::Base
  SHIPPING_METHODS = ['Ground','2nd Day','Overnight','International'].freeze
  SHIPPING_RATES = {
    'Ground' =>         [Money.new(795),  Money.new(995),  Money.new(1495), Money.new(1795), Money.new(1995), Money.new(2495)],
    '2nd Day' =>        [Money.new(1795),  Money.new(1995),  Money.new(2495), Money.new(2795), Money.new(2995), Money.new(3495)],
    'Overnight' =>      [Money.new(2795),  Money.new(2995),  Money.new(3495), Money.new(3795), Money.new(3995), Money.new(4495)],
    'International' =>  [Money.new(3000),  Money.new(5400),  Money.new(7500), Money.new(10000), Money.new(12500)]
  }.freeze
  SHIPPING_RANGES = [
    [Money.new(0),Money.new(9999)],
    [Money.new(10000),Money.new(19999)],
    [Money.new(20000),Money.new(29999)],
    [Money.new(30000),Money.new(39999)],
    [Money.new(40000),Money.new(49999)],
    [Money.new(50000),Money.new(50000000)]
  ].freeze
  include FormatsErrors
  belongs_to :user
  belongs_to :coupon
  has_many :order_items, :dependent => :destroy
  has_many :product_options, :through => :order_items
  has_one :billing_address, :dependent => :destroy
  has_one :shipping_address, :dependent => :destroy
  has_many :addresses, :dependent => :destroy
  after_create :add_addresses
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
      if product_option.inventory_quantity != nil and product_option.inventory_quantity > 0
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
  
  def ground_only?
    Product.find_by_sql(["select products.id from products inner join product_options on product_options.product_id = products.id inner join order_items on order_items.product_option_id = product_options.id inner join orders on orders.id = order_items.order_id where orders.id = ? and products.ground_price > 0", self.id]).any?
  end
  
  def update_shipping
    if self.shipping_address
      if self.shipping_address.country_id != 465 #USA
        self.shipping_method = 'International'
      else
        if self.shipping_method == 'International'
          self.shipping_method = 'Ground'
        end
      end
    end
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
    if this_range_index == 5
      this_rate = self.shipping_over
    else
      this_rate = SHIPPING_RATES[self.shipping_method][this_range_index]
    end
    this_rate += Money.new(Product.find_by_sql(["select sum(products.ground_price * order_items.quantity) as shipping_total from products inner join product_options on product_options.product_id = products.id inner join order_items on order_items.product_option_id = product_options.id inner join orders on orders.id = order_items.order_id where orders.id = ?", self.id]).first.shipping_total.to_i)
  end
  
  def shipping_over
    case self.shipping_method
    when 'International'
      Money.new(12500) + Money.new((((self.subtotal - Money.new(49999)).to_s.to_f / 100).truncate + 1) * 2500)
    else
      SHIPPING_RATES[self.shipping_method][5]
    end
  end
  
  def calculate_subtotal
    self.order_items.sum("price * quantity").to_i - self.discount
  end
  
  def pre_discount_subtotal
    Money.new(self.order_items.sum("price * quantity").to_i)
  end
  
  def discount
    if self.coupon
      if self.coupon.percent_off > 0
        return (self.coupon.percent_off / 100.0) * self.order_items.sum("price * quantity").to_i
      elsif self.coupon.flat_amount > Money.new(0)
        if self.coupon.flat_amount <= self.pre_discount_subtotal
          return self.coupon.flat_amount.cents.to_i
        else
          return 0
        end
      end
    else
      return 0
    end
  end
  
  def discount_money
    Money.new(self.discount)
  end
  
  def calculate_sales_tax
    self.subtotal * 0.05
  end
  
  def add_addresses
    self.billing_address = BillingAddress.create(:order_id => self.id,:country_id => 465)
    self.shipping_address = ShippingAddress.create(:order_id => self.id,:country_id => 465)
  end
  
  def validate
    self.errors.add(:coupon_id,"We couldn't validate that coupon code.") if self.coupon and !self.coupon.useable?
  end
  
  CARD_MONTHS = ['1','2','3','4','5','6','7','8','9','10','11','12'].freeze
  CARD_YEARS = Array.new(8) {|i| (i + Date.today.year).to_s}
  SHIPPING_METHODS = ['Ground','2nd Day','Overnight'].freeze
end
