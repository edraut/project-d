class ProductVehicleMake < ActiveRecord::Base
  include FormatsErrors
  belongs_to :product
  belongs_to :vehicle_make
end