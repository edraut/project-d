class Manage::ProductsController < Manage::ApplicationController
  before_filter :get_product, :only => [:show,:edit,:update,:destroy]
  before_filter :prepare_params, :only => [:create,:update]
  before_filter :manage_money, :only => [:create,:update]
  def index
    @products = Product.find(:all)
    @product = nil
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
    @product = Product.new(@editable_params)

    if @product.save
      flash[:notice] = 'Product was successfully created.'
      render :template => 'manage/products/edit' and return
    else
      @products = Product.find(:all)
      render :template => 'manage/products/index' and return
    end
  end

  # PUT /manage_products/1
  # PUT /manage_products/1.xml
  def update
    if @product.update_attributes(@editable_params)
      for product_size in @product.product_sizes
        product_size.price = @editable_size_params[product_size.size_id.to_s][:price]
        product_size.save
      end
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
  def prepare_params
    @editable_params = params[:product].dup
    @money_attributes = [:price]
    if params.has_key? :product_sizes
      @editable_size_params = params[:product_sizes].dup
      for size_id in params[:product][:size_ids]
        @editable_size_params[size_id.to_s][:price] = string_to_money(@editable_size_params[size_id.to_s][:price])
      end
    end
  end
end
