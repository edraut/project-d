class Color < ActiveRecord::Base
  include FormatsErrors
  belongs_to :color_group
end