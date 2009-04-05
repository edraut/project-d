class ProductColor < ActiveRecord::Base
  include FormatsErrors
  belongs_to :product
  belongs_to :color
end