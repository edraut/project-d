class Manage::ApplicationController < ApplicationController
  helper :all # include all helpers, all the time
  before_filter :login_required


  filter_parameter_logging :credit_card_number, :credit_card_month, :credit_card_year, :credit_card_cvv
  
  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password
  def set_nav_area
    @nav_area = 'manage'
  end
end
