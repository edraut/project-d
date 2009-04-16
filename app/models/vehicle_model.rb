class VehicleModel < ActiveRecord::Base
  include FormatsErrors
  belongs_to :vehicle_type
  has_many :product_option_vehicle_models
end