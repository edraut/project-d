class Manufacturer < ActiveRecord::Base
  include FormatsErrors
  has_many :products
end