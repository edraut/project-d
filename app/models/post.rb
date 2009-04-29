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
  def validate
    self.errors.add_to_base("Must have at least a title, image or body text.") if self.title.blank? and self.body.blank? and !self.image.exists?
  end
end