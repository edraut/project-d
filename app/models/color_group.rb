class ColorGroup < ActiveRecord::Base
  include FormatsErrors
  has_many :colors, :dependent => :destroy
end