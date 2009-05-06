class Address < ActiveRecord::Base
  include FormatsErrors
  belongs_to :user
  belongs_to :order
  belongs_to :country
  after_save :update_order_sales_tax
  
  named_scope :id_only, :conditions => {:status => 'id_only'}
  named_scope :live, :conditions => {:status => 'live'}
  
  state_machine :status, :initial => :id_only do
    event :user_input do
      transition :id_only => :live
    end
    state :id_only do
    end
    state :live do
      validates_presence_of :first_name, :last_name, :address_1, :city, :zipcode
    end
  end
  
  def full_name
    [self.first_name, self.middle_initial, self.last_name].compact.join(' ')
  end
  
  def usa?
    self.new_record? or self.country_id == 465
  end
  
  def editable?
    self.order.nil? or self.status != 'live' or ['cart','card_rejected'].include? self.order.state
  end
  
  def update_order_sales_tax
    if self.order
      self.order.save
    end
  end
  
  def self.create_or_find_by_order_id(order_id)
    address = self.find(:first, :conditions => {:order_id => order_id})
    address ||= self.create(:order_id => order_id)
    return address
  end
  
  STATES = [["Alabama",	                            "AL"],
            ["Arizona",	                            "AZ"],
            ["Arkansas",	                          "AR"],
            ["California",	                        "CA"],
            ["Colorado",	                          "CO"],
            ["Connecticut",	                        "CT"],
            ["Delaware",	                          "DE"],
            ["District of Columbia",	              "DC"],
            ["Florida",	                            "FL"],
            ["Georgia",	                            "GA"],
            ["Idaho",	                              "ID"],
            ["Illinois",	                          "IL"],
            ["Indiana",	                            "IN"],
            ["Iowa",	                              "IA"],
            ["Kansas",	                            "KS"],
            ["Kentucky",	                          "KY"],
            ["Louisiana",	                          "LA"],
            ["Maine",	                              "ME"],
            ["Maryland",	                          "MD"],
            ["Massachusetts",	                      "MA"],
            ["Michigan",	                          "MI"],
            ["Minnesota",	                          "MN"],
            ["Mississippi",	                        "MS"],
            ["Missouri",	                          "MO"],
            ["Montana",	                            "MT"],
            ["Nebraska",	                          "NE"],
            ["Nevada",	                            "NV"],
            ["New Hampshire",	                      "NH"],
            ["New Jersey",	                        "NJ"],
            ["New Mexico",	                        "NM"],
            ["New York",	                          "NY"],
            ["North Carolina",	                    "NC"],
            ["North Dakota",	                      "ND"],
            ["Ohio",	                              "OH"],
            ["Oklahoma",	                          "OK"],
            ["Oregon",	                            "OR"],
            ["Pennsylvania",	                      "PA"],
            ["Rhode Island",	                      "RI"],
            ["South Carolina",	                    "SC"],
            ["South Dakota",	                      "SD"],
            ["Tennessee",	                          "TN"],
            ["Texas",	                              "TX"],
            ["Utah",	                              "UT"],
            ["Vermont",	                            "VT"],
            ["Virginia",	                          "VA"],
            ["Washington",	                        "WA"],
            ["West Virginia",	                      "WV"],
            ["Wisconsin",	                          "WI"],
            ["Wyoming",	                            "WY"]]
end