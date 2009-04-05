class Manage::VehicleMakesController < Manage::ApplicationController
  before_filter :get_vehicle_make, :only => [:show,:edit,:update,:destroy]

  def index
    @vehicle_makes = VehicleMake.find(:all)

  end

  # GET /manage_vehicle_makes/1
  # GET /manage_vehicle_makes/1.xml
  def show
    render :partial => 'show', :object => @vehicle_make
  end

  # GET /manage_vehicle_makes/new
  # GET /manage_vehicle_makes/new.xml
  def new
    @vehicle_make = VehicleMake.new
    @product = Product.find(params[:product_id].to_i) if params.has_key? :product_id

    render :partial => 'new', :object => @vehicle_make
  end

  # GET /manage_vehicle_makes/1/edit
  def edit
    render :partial => 'edit', :object => @vehicle_make
    
  end

  # POST /manage_vehicle_makes
  # POST /manage_vehicle_makes.xml
  def create
    @vehicle_make = VehicleMake.new(params[:vehicle_make])

    if @vehicle_make.save
      flash[:notice] = 'VehicleMake was successfully created.'
      if params[:product_id]
        render :partial => 'select_option', :object => @vehicle_make
      else
        render :partial => 'element_container', :object => @vehicle_make
      end
    else
      render :partial => 'new', :object => @vehicle_make, :status => 409
    end
  end

  # PUT /manage_vehicle_makes/1
  # PUT /manage_vehicle_makes/1.xml
  def update

    if @vehicle_make.update_attributes(params[:vehicle_make])
      flash[:notice] = 'VehicleMake was successfully updated.'
      render :partial => 'show', :object => @vehicle_make
    else
      render :partial => 'edit', :object => @vehicle_make, :status => 409
    end
  end

  # DELETE /manage_vehicle_makes/1
  # DELETE /manage_vehicle_makes/1.xml
  def destroy
    @vehicle_make.destroy

    render :nothing => true
  end

  private
  def get_vehicle_make
    @vehicle_make = VehicleMake.find(params[:id])
  end
end
