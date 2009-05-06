class Notifier < ActionMailer::Base
  def order_confirmation(order)
    recipients order.email
    from       "contact@madracingmx.com"
    subject    "Your Order Information"
    body       :order => order
  end
  

end
