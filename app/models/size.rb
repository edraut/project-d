class Size < ActiveRecord::Base
  include FormatsErrors
  belongs_to :size_group
end