class Manage::ManufacturersController < Manage::ApplicationController
  before_filter :get_manufacturer, :only => [:show,:edit,:update,:destroy]

  def index
    @manufacturers = Manufacturer.find(:all)

  end

  # GET /manage_manufacturers/1
  # GET /manage_manufacturers/1.xml
  def show
    render :partial => 'element_container', :object => @manufacturer
  end

  # GET /manage_manufacturers/new
  # GET /manage_manufacturers/new.xml
  def new
    @manufacturer = Manufacturer.new

    render :partial => 'new', :object => @manufacturer
  end

  # GET /manage_manufacturers/1/edit
  def edit
    render :partial => 'edit', :object => @manufacturer
    
  end

  # POST /manage_manufacturers
  # POST /manage_manufacturers.xml
  def create
    @manufacturer = Manufacturer.new(params[:manufacturer])

    if @manufacturer.save
      flash[:notice] = 'Manufacturer was successfully created.'
      render :partial => 'element_container', :object => @manufacturer
    else
      render :partial => 'new', :object => @manufacturer, :status => 409
    end
  end

  # PUT /manage_manufacturers/1
  # PUT /manage_manufacturers/1.xml
  def update

    if @manufacturer.update_attributes(params[:manufacturer])
      flash[:notice] = 'Manufacturer was successfully updated.'
      render :partial => 'show', :object => @manufacturer
    else
      render :partial => 'edit', :object => @manufacturer, :status => 409
    end
  end

  # DELETE /manage_manufacturers/1
  # DELETE /manage_manufacturers/1.xml
  def destroy
    @manufacturer.destroy

    render :nothing => true
  end

  private
  def get_manufacturer
    @manufacturer = Manufacturer.find(params[:id])
  end
end
