class ProductImage < ActiveRecord::Base
  include FormatsErrors
  belongs_to :product
  has_attached_file :image,
    :styles => {
      :small => "70x70#",
      :medium => "150x150>",
      :large => "390x390>"
    }
end