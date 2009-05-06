class CreateMorePages < ActiveRecord::Migration
  def self.up
    policies = Page.create(:name => 'Policies')
    contact = Page.create(:name => 'Contact Us')
    Post.create(:postable_type => 'Page', :postable_id => policies.id, :title => 'Coming Soon!')
    Post.create(:postable_type => 'Page', :postable_id => contact.id, :title => 'Coming Soon!')
    
  end

  def self.down
    Page.find_by_name('Policies').destroy
    Page.find_by_name('Contact Us').destroy
  end
end
