class Post < ActiveRecord::Base
  include FormatsErrors
  belongs_to :postable, :polymorphic => true
  has_attached_file :image,
    :url => "/system/:class/:id/:style/:basename.:extension",
    :path => ":rails_root/public/system/:class/:id/:style/:basename.:extension",
    :styles => {
      :small => "70x70#",
      :medium => "110x110>",
      :large => "390x390>",
      :full_width => "578x578>"
    }
end