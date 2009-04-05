class ColorGroup < ActiveRecord::Base
  include FormatsErrors
  has_many :colors, :dependent => :destroy
  validates_uniqueness_of :name
end