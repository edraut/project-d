class UserMailer < ActionMailer::Base
  def signup_notification(user)
    setup_email(user)
    @subject    += 'Please activate your new account'
  
    @body[:url]  = WEB_SITE_URL + "/activate/#{user.activation_code}"
  
  end
  
  def activation(user)
    setup_email(user)
    @subject    += 'Your account has been activated!'
    @body[:url]  = WEB_SITE_URL
  end
  
  protected
    def setup_email(user)
      @recipients  = "#{user.email}"
      @from        = "do-not-reply@madracingmx.com"
      @subject     = "MADRACINGMX.COM "
      @sent_on     = Time.now
      @body[:user] = user
    end
end
