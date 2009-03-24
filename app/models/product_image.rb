class ProductImage < ActiveRecord::Base
  belongs_to :product
  has_attached_file :image,
    :styles => {
      :small => "69x69#",
      :medium => "151x151>",
      :large => "438x438>"
    }
end