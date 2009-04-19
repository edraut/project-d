class Country < ActiveRecord::Base
  named_scope :sorted, :order => :position
end