require 'open-uri'
class ProductImage < ActiveRecord::Base
  include FormatsErrors
  belongs_to :product
  has_attached_file :image,
    :url => "/system/:class/:id/:style/:basename.:extension",
    :path => ":rails_root/public/system/:class/:id/:style/:basename.:extension",
    :styles => {
      :small => "70x70#",
      :medium => "110x110>",
      :large => "390x390>"
    }
  attr_accessor :image_url
  before_validation :download_remote_image, :if => :image_url_provided?

  validates_presence_of :image_remote_url, :if => :image_url_provided?, :message => 'is invalid or inaccessible'

private

  def image_url_provided?
    !self.image_url.blank?
  end

  def download_remote_image
    self.image = do_download_remote_image
    self.image_remote_url = image_url
  end

  def do_download_remote_image
    io = open(URI.parse(image_url))
    def io.original_filename; base_uri.path.split('/').last; end
    io.original_filename.blank? ? nil : io
  rescue # catch url errors with validations instead of exceptions (Errno::ENOENT, OpenURI::HTTPError, etc...)
  end
end