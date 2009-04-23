namespace :utils do
  task (:clean_up_old_carts => :environment) do
    Order.carts.find(:all, :conditions => ["created_at < (current_timestamp - interval '1 day')"]).each do |cart|
      cart.destroy
    end
  end
end