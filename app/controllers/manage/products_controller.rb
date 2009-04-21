class Manage::ProductsController < Manage::ApplicationController
  before_filter :get_product, :only => [:show,:edit,:update,:destroy]
  before_filter :prepare_params, :only => [:create,:update]
  before_filter :manage_money, :only => [:create,:update]
  def index
    if params.has_key? :featured
      @featured = true
      @products = Product.paginate(:all, :conditions => {:featured => true}, :per_page => 25, :page => params[:page])
    else
      prepare_products(25)
    end
    @product = nil
  end

  # GET /manage_products/1
  # GET /manage_products/1.xml
  def show
    if params[:id].to_i == 0
      render :template => 'manage/products/' + params[:id] and return
    else
      @product_section = 'overview'
    end
  end

  # GET /manage_products/new
  # GET /manage_products/new.xml
  def new
    @product = Product.new
  end

  # GET /manage_products/1/edit
  def edit
    if params.has_key? :product_section
      @product_section = params[:product_section]
      case params[:product_section]
      when 'info'
        render :template => 'manage/products/edit' and return
      when 'options'
        render :template => 'manage/products/options_images_form' and return
      end
    end
  end

  # POST /manage_products
  # POST /manage_products.xml
  def create
    @product = Product.new(@editable_params)

    if @product.save
      @product_section = 'options'
      render :template => 'manage/products/options_images_form' and return
    else
      @products = Product.find(:all)
      render :template => 'manage/products/index' and return
    end
  end

  # PUT /manage_products/1
  # PUT /manage_products/1.xml
  def update
    @product.send(params[:event]) if params.has_key? :event
    if params.has_key? :product and @product.update_attributes(@editable_params)
      @product_section = 'overview'
      render :template => 'manage/products/show' and return
    elsif !params.has_key? :product
      @product_section = 'overview'
      render :template => 'manage/products/show' and return
    else
      @product_section = 'info'
      render :template => 'manage/products/edit' and return
    end
  end

  # DELETE /manage_products/1
  # DELETE /manage_products/1.xml
  def destroy
    @product.destroy
    @products = Product.paginate(:page => params[:page], :per_page => 25)
    render :template => 'manage/products/index' and return
  end
  
  private
  def get_product
    @product = Product.find(params[:id]) unless params[:id].to_i == 0
  end
  def prepare_params
    if params.has_key? :product
      @editable_params = params[:product].dup
      @money_attributes = [:ground_price, :second_day_price, :overnight_price, :international_price]
    end
  end
end
