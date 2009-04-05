# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  before_filter :set_nav_area
  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  # protect_from_forgery # :secret => '43c771a06b224b59eadad4cc84ca056e'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password
  def string_to_money(string)
    Money.new(string.to_f * 100)
  end
  
  def manage_money
    if @editable_params and @editable_params.is_a? Hash
      for money_attribute in @money_attributes
        @editable_params[money_attribute] = string_to_money(@editable_params[money_attribute])
      end
    end
  end
  
  def set_nav_area
    @nav_area = 'public'
  end

end
