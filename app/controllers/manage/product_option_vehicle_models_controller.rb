class Manage::ProductOptionVehicleModelsController < Manage::ApplicationController
  before_filter :get_product_option_vehicle_model, :only => [:show,:edit,:update,:destroy]

  def index
    if params.has_key? :owner_id and params.has_key? :owner_type
      owner_class = params[:owner_type].constantize
      owner_assoc_name = params[:owner_type].underscore
      if params.has_key? owner_assoc_name and params[owner_assoc_name].has_key? :vehicle_make_ids
        @vehicle_makes = VehicleMake.find(params[owner_assoc_name][:vehicle_make_ids])
        @vehicle_models = VehicleModel.find(:all, :conditions => {:vehicle_make_id => params[owner_assoc_name][:vehicle_make_ids]}, :order => 'vehicle_type_id, name')
      else
        @vehicle_makes = []
        @vehicle_models = []
      end
      @owner = owner_class.find(params[:owner_id])
      @existing_vehicle_models = @owner.vehicle_models
      @unused_vehicle_models = @vehicle_models - @existing_vehicle_models
      @product_option_vehicle_models = @owner.product_option_vehicle_models
      logger.info("PRODUCT_OPTION: #{@owner.name}")
      logger.info("EXISTING_CLASS: #{@existing_vehicle_models.first.class.name} EXISTING_IDS: #{@existing_vehicle_models.map{|x| x.name}.inspect}")
      logger.info("MODELS FOR MAKE: #{@vehicle_models.map{|x| x.name}.inspect}")
      logger.info("UNUSED: #{@unused_vehicle_models.map{|x| x.name}.inspect}")
      render :partial => params[:ui_element] and return
    end
    @product_option_vehicle_models = ProductOptionVehicleModel.find(:all)

  end

  # GET /manage_product_option_vehicle_models/1
  # GET /manage_product_option_vehicle_models/1.xml
  def show
    render :partial => 'show', :object => @product_option_vehicle_model
  end

  # GET /manage_product_option_vehicle_models/new
  # GET /manage_product_option_vehicle_models/new.xml
  def new
    @product_option_vehicle_model = ProductOptionVehicleModel.new

    render :partial => 'new', :object => @product_option_vehicle_model
  end

  # GET /manage_product_option_vehicle_models/1/edit
  def edit
    render :partial => 'edit', :object => @product_option_vehicle_model
    
  end

  # POST /manage_product_option_vehicle_models
  # POST /manage_product_option_vehicle_models.xml
  def create
    @product_option_vehicle_model = ProductOptionVehicleModel.new(params[:product_option_vehicle_model])

    if @product_option_vehicle_model.save
      flash[:notice] = 'ProductOptionVehicleModel was successfully created.'
      render :partial => 'element_container', :object => @product_option_vehicle_model
    else
      render :partial => 'new', :object => @product_option_vehicle_model, :status => 409
    end
  end

  # PUT /manage_product_option_vehicle_models/1
  # PUT /manage_product_option_vehicle_models/1.xml
  def update

    if @product_option_vehicle_model.update_attributes(params[:product_option_vehicle_model])
      flash[:notice] = 'ProductOptionVehicleModel was successfully updated.'
      render :partial => 'show', :object => @product_option_vehicle_model
    else
      render :partial => 'edit', :object => @product_option_vehicle_model, :status => 409
    end
  end

  # DELETE /manage_product_option_vehicle_models/1
  # DELETE /manage_product_option_vehicle_models/1.xml
  def destroy
    @product_option_vehicle_model.destroy

    render :nothing => true
  end

  private
  def get_product_option_vehicle_model
    @product_option_vehicle_model = ProductOptionVehicleModel.find(params[:id])
  end
end
