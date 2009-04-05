class VehicleMake < ActiveRecord::Base
  include FormatsErrors
  has_many :vehicle_models, :order => 'vehicle_type_id, name'
  has_many :product_vehicle_makes
end