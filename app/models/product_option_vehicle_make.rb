class ProductOptionVehicleMake < ActiveRecord::Base
  include FormatsErrors
  belongs_to :product_option
  belongs_to :vehicle_make
end