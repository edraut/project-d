class Size < ActiveRecord::Base
  include FormatsErrors
  belongs_to :size_group
  validates_uniqueness_of :name, :scope => :size_group_id
end