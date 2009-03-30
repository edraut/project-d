class ProductSize < ActiveRecord::Base
  include FormatsErrors
  belongs_to :product
end