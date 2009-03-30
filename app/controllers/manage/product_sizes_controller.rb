class Manage::ProductSizesController < Manage::ApplicationController
  before_filter :get_product_size, :only => [:show,:edit,:update,:destroy]

  def index
    @product_sizes = ProductSize.find(:all)

  end

  # GET /manage_product_sizes/1
  # GET /manage_product_sizes/1.xml
  def show
    render :partial => 'element_container', :object => @product_size
  end

  # GET /manage_product_sizes/new
  # GET /manage_product_sizes/new.xml
  def new
    @product_size = ProductSize.new

    render :partial => 'new', :object => @product_size
  end

  # GET /manage_product_sizes/1/edit
  def edit
    render :partial => 'edit', :object => @product_size
    
  end

  # POST /manage_product_sizes
  # POST /manage_product_sizes.xml
  def create
    @product_size = ProductSize.new(params[:product_size])

    if @product_size.save
      flash[:notice] = 'ProductSize was successfully created.'
      render :partial => 'element_container', :object => @product_size
    else
      render :partial => 'new', :object => @product_size, :status => 409
    end
  end

  # PUT /manage_product_sizes/1
  # PUT /manage_product_sizes/1.xml
  def update

    if @product_size.update_attributes(params[:product_size])
      flash[:notice] = 'ProductSize was successfully updated.'
      render :partial => 'show', :object => @product_size
    else
      render :partial => 'edit', :object => @product_size, :status => 409
    end
  end

  # DELETE /manage_product_sizes/1
  # DELETE /manage_product_sizes/1.xml
  def destroy
    @product_size.destroy

    render :nothing => true
  end

  private
  def get_product_size
    @product_size = ProductSize.find(params[:id])
  end
end
