# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def strip_tags(string)
    string.gsub(/<[^>]*>/,'')
  end
  
  
end
