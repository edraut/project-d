class VehicleModel < ActiveRecord::Base
  include FormatsErrors
  has_many :product_vehicle_models
end