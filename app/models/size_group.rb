class SizeGroup < ActiveRecord::Base
  include FormatsErrors
  has_many :sizes, :dependent => :destroy
end