class VehicleType < ActiveRecord::Base
  include FormatsErrors
  has_many :vehicle_models
end