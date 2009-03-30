class ProductColor < ActiveRecord::Base
  include FormatsErrors
  belongs_to :product
end