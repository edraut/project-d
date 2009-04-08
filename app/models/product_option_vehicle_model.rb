class ProductOptionVehicleModel < ActiveRecord::Base
  include FormatsErrors
  belongs_to :product_option
  belongs_to :vehicle_model
end