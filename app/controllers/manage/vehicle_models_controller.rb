class Manage::VehicleModelsController < Manage::ApplicationController
  before_filter :get_vehicle_model, :only => [:show,:edit,:update,:destroy]

  def index
    if params.has_key? :product_id
      if params.has_key? :product and params[:product].has_key? :vehicle_make_ids
        @vehicle_models = VehicleModel.find(:all, :conditions => {:vehicle_make_id => params[:product][:vehicle_make_ids]})
      else
        @vehicle_models = []
      end
      @product = Product.find(params[:product_id]) if params[:product_id]
      render :partial => 'select' and return
    end
    @vehicle_models = VehicleModel.find(:all)
  end

  # GET /manage_vehicle_models/1
  # GET /manage_vehicle_models/1.xml
  def show
    render :partial => 'element_container', :object => @vehicle_model
  end

  # GET /manage_vehicle_models/new
  # GET /manage_vehicle_models/new.xml
  def new
    @vehicle_model = VehicleModel.new

    render :partial => 'new', :object => @vehicle_model
  end

  # GET /manage_vehicle_models/1/edit
  def edit
    render :partial => 'edit', :object => @vehicle_model
    
  end

  # POST /manage_vehicle_models
  # POST /manage_vehicle_models.xml
  def create
    @vehicle_model = VehicleModel.new(params[:vehicle_model])

    if @vehicle_model.save
      flash[:notice] = 'VehicleModel was successfully created.'
      render :partial => 'element_container', :object => @vehicle_model
    else
      render :partial => 'new', :object => @vehicle_model, :status => 409
    end
  end

  # PUT /manage_vehicle_models/1
  # PUT /manage_vehicle_models/1.xml
  def update

    if @vehicle_model.update_attributes(params[:vehicle_model])
      flash[:notice] = 'VehicleModel was successfully updated.'
      render :partial => 'show', :object => @vehicle_model
    else
      render :partial => 'edit', :object => @vehicle_model, :status => 409
    end
  end

  # DELETE /manage_vehicle_models/1
  # DELETE /manage_vehicle_models/1.xml
  def destroy
    @vehicle_model.destroy

    render :nothing => true
  end

  private
  def get_vehicle_model
    @vehicle_model = VehicleModel.find(params[:id])
  end
end
