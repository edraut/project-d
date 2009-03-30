class Manage::ProductsController < Manage::ApplicationController
  before_filter :get_product, :only => [:show,:edit,:update,:destroy]

  def index
    @products = Product.find(:all)

  end

  # GET /manage_products/1
  # GET /manage_products/1.xml
  def show
  end

  # GET /manage_products/new
  # GET /manage_products/new.xml
  def new
    @product = Product.new
  end

  # GET /manage_products/1/edit
  def edit
  end

  # POST /manage_products
  # POST /manage_products.xml
  def create
    @product = Product.new(params[:product])

    if @product.save
      flash[:notice] = 'Product was successfully created.'
      render :template => 'manage/products/edit' and return
    else
      render :template => 'manage/products/new' and return
    end
  end

  # PUT /manage_products/1
  # PUT /manage_products/1.xml
  def update

    if @product.update_attributes(params[:product])
      flash[:notice] = 'Product was successfully updated.'
      render :template => 'manage/products/show' and return
    else
      render :template => 'manage/products/edit' and return
    end
  end

  # DELETE /manage_products/1
  # DELETE /manage_products/1.xml
  def destroy
    @product.destroy
    @products = Product.all
    render :template => 'manage/products/index' and return
  end

  private
  def get_product
    @product = Product.find(params[:id])
  end
end
