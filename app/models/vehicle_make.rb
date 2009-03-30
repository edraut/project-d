class VehicleMake < ActiveRecord::Base
  include FormatsErrors
  has_many :vehicle_models
  has_many :product_vehicle_makes
end