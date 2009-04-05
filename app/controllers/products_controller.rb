class ProductsController < ApplicationController
  before_filter :get_product, :only => [:show,:edit,:update,:destroy]

  def index
    @products = Product.find(:all)

  end

  # GET /products/1
  # GET /products/1.xml
  def show
  end

  # GET /products/new
  # GET /products/new.xml
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products
  # POST /products.xml
  def create
    @product = Product.new(params[:product])

    if @product.save
      flash[:notice] = 'Product was successfully created.'
      render :template => 'products/show' and return
    else
      render :template => 'products/new' and return
    end
  end

  # PUT /products/1
  # PUT /products/1.xml
  def update

    if @product.update_attributes(params[:product])
      flash[:notice] = 'Product was successfully updated.'
      render :template => 'products/show' and return
    else
      render :template => 'products/edit' and return
    end
  end

  # DELETE /products/1
  # DELETE /products/1.xml
  def destroy
    @product.destroy
    @products = Product.all
    render :template => 'products/index' and return
  end

  private
  def get_product
    @product = Product.find(params[:id])
  end
end
