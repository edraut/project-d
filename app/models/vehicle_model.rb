class VehicleModel < ActiveRecord::Base
  include FormatsErrors
  belongs_to :vehicle_type
  has_many :product_option_vehicle_models
  after_save :update_tsearch_vectors

  acts_as_tsearch :fields => ["name"]

  def update_tsearch_vectors
    self.class.update_vectors
  end
end