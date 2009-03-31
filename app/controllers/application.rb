# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '43c771a06b224b59eadad4cc84ca056e'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password
  def string_to_money(string)
    Money.new((string.to_f * 100).to_i)
  end
  
  def manage_money
    for money_attribute in @money_attributes
      logger.info("MONEY: #{}")
      @editable_params[money_attribute] = string_to_money(@editable_params[money_attribute])
      logger.info("MONEY: #{@editable_params[:price]}")
    end
  end

end
