class AddHomeAboutPosts < ActiveRecord::Migration
  def self.up
    Post.reset_column_information
    Page.reset_column_information
    home = Page.find_by_name('Home')
    about = Page.find_by_name('About Us')
    news = Page.find_by_name('News')
    Post.create(:postable_type => 'Page', :postable_id => home.id, :title => 'WELCOME TO MAD RACING MX!', :body => "p=(orange). Check back often, we're adding new products daily!")
    Post.create(:postable_type => 'Page', :postable_id => about.id, :title => 'Coming Soon!')
    Post.create(:postable_type => 'Page', :postable_id => news.id, :title => 'Coming Soon!')
  end

  def self.down
    Post.delete_all
  end
end
