class Color < ActiveRecord::Base
  include FormatsErrors
  belongs_to :color_group
  validates_uniqueness_of :name, :scope => :color_group_id
end