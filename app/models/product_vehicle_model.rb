class ProductVehicleModel < ActiveRecord::Base
  include FormatsErrors
  belongs_to :product
  belongs_to :vehicle_model
end