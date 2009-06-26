class PagesController < ApplicationController
  # before_filter :get_page, :only => [:show,:edit,:update,:destroy]

  def index
    @pages = Page.find(:all)

  end

  # GET /pages/1
  # GET /pages/1.xml
  def show
    case params[:name]
    when 'about'
      page_name = 'About Us'
    when 'news'
      page_name = 'News'
    when 'policies'
      page_name = 'Policies'
    when 'contact'
      page_name = 'Contact Us'
    end
    @page = Page.find_by_name(page_name)
    @posts = @page.posts.published.paginate(:page => params[:page], :per_page => 4) if page_name == 'News'
    
    render :template => 'pages/' + params[:name] and return
  end

  def home
    @nav_tab = 'home'
    @products = Product.featured.published.find(:all, :limit => 16)
    @specials = Product.specials.published.find(:all, :limit => 4)
    @page = Page.find_by_name('Home')
    @post = @page.posts.first
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
