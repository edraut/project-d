class ProductSize < ActiveRecord::Base
  include FormatsErrors
  belongs_to :product
  belongs_to :size
end