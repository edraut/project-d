class SizeGroup < ActiveRecord::Base
  include FormatsErrors
  has_many :sizes, :dependent => :destroy
  validates_uniqueness_of :name
end