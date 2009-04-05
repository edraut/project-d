class ProductImage < ActiveRecord::Base
  include FormatsErrors
  belongs_to :product
  has_attached_file :image,
    :url => "/system/:class/:id/:style/:basename.:extension",
    :path => ":rails_root/public/system/:class/:id/:style/:basename.:extension",
    :styles => {
      :small => "70x70#",
      :medium => "150x150>",
      :large => "390x390>"
    }
end