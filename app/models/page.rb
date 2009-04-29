class Page < ActiveRecord::Base
  has_many :posts, :as => :postable, :order => 'created_at desc'
  
  def self.display_name
    'Page'
  end
  
  def self.post_quantity_for(page_name)
    case page_name
    when 'Home'
      1
    when 'About Us'
      1
    when 'News'
      100000
    end
  end
end