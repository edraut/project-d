class Manage::VehicleTypesController < Manage::ApplicationController
  before_filter :get_vehicle_type, :only => [:show,:edit,:update,:destroy]

  def index
    @vehicle_types = VehicleType.find(:all)

  end

  # GET /manage_vehicle_types/1
  # GET /manage_vehicle_types/1.xml
  def show
    render :partial => 'show', :object => @vehicle_type
  end

  # GET /manage_vehicle_types/new
  # GET /manage_vehicle_types/new.xml
  def new
    @vehicle_type = VehicleType.new

    render :partial => 'new', :object => @vehicle_type
  end

  # GET /manage_vehicle_types/1/edit
  def edit
    render :partial => 'edit', :object => @vehicle_type
    
  end

  # POST /manage_vehicle_types
  # POST /manage_vehicle_types.xml
  def create
    @vehicle_type = VehicleType.new(params[:vehicle_type])

    if @vehicle_type.save
      flash[:notice] = 'VehicleType was successfully created.'
      render :partial => 'element_container', :object => @vehicle_type
    else
      render :partial => 'new', :object => @vehicle_type, :status => 409
    end
  end

  # PUT /manage_vehicle_types/1
  # PUT /manage_vehicle_types/1.xml
  def update

    if @vehicle_type.update_attributes(params[:vehicle_type])
      flash[:notice] = 'VehicleType was successfully updated.'
      render :partial => 'show', :object => @vehicle_type
    else
      render :partial => 'edit', :object => @vehicle_type, :status => 409
    end
  end

  # DELETE /manage_vehicle_types/1
  # DELETE /manage_vehicle_types/1.xml
  def destroy
    @vehicle_type.destroy

    render :nothing => true
  end

  private
  def get_vehicle_type
    @vehicle_type = VehicleType.find(params[:id])
  end
end
