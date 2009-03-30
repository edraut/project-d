class Manage::ProductColorsController < Manage::ApplicationController
  before_filter :get_product_color, :only => [:show,:edit,:update,:destroy]

  def index
    @product_colors = ProductColor.find(:all)

  end

  # GET /manage_product_colors/1
  # GET /manage_product_colors/1.xml
  def show
    render :partial => 'element_container', :object => @product_color
  end

  # GET /manage_product_colors/new
  # GET /manage_product_colors/new.xml
  def new
    @product_color = ProductColor.new

    render :partial => 'new', :object => @product_color
  end

  # GET /manage_product_colors/1/edit
  def edit
    render :partial => 'edit', :object => @product_color
    
  end

  # POST /manage_product_colors
  # POST /manage_product_colors.xml
  def create
    @product_color = ProductColor.new(params[:product_color])

    if @product_color.save
      flash[:notice] = 'ProductColor was successfully created.'
      render :partial => 'element_container', :object => @product_color
    else
      render :partial => 'new', :object => @product_color, :status => 409
    end
  end

  # PUT /manage_product_colors/1
  # PUT /manage_product_colors/1.xml
  def update

    if @product_color.update_attributes(params[:product_color])
      flash[:notice] = 'ProductColor was successfully updated.'
      render :partial => 'show', :object => @product_color
    else
      render :partial => 'edit', :object => @product_color, :status => 409
    end
  end

  # DELETE /manage_product_colors/1
  # DELETE /manage_product_colors/1.xml
  def destroy
    @product_color.destroy

    render :nothing => true
  end

  private
  def get_product_color
    @product_color = ProductColor.find(params[:id])
  end
end
