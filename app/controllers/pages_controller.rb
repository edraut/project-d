class PagesController < ApplicationController
  # before_filter :get_page, :only => [:show,:edit,:update,:destroy]

  def index
    @pages = Page.find(:all)

  end

  # GET /pages/1
  # GET /pages/1.xml
  def show
    render :template => 'pages/' + params[:name] and return
  end


  protected
  def set_nav_tab
    @nav_tab = params[:name]
  end
  private
  def get_page
    @page = Page.find_by_name(params[:name])
  end
end
