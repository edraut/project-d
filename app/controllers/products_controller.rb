class ProductsController < ApplicationController
  before_filter :get_product, :only => [:show,:edit,:update,:destroy]

  def index
    if params.has_key? :special_group
      @special_group = params[:special_group]
      @products = Product.send(params[:special_group]).paginate(:per_page => 16, :page => params[:page])
    else
      prepare_products(16,'published')
    end
  end

  # GET /products/1
  # GET /products/1.xml
  def show
    @product.hit
    @categories = @product.categories
    @vehicle_make = VehicleMake.find(params[:vehicle_make_id].to_i) if params[:vehicle_make_id]
    @vehicle_model = VehicleModel.find(params[:vehicle_model_id].to_i) if params[:vehicle_model_id]
    @vehicle_makes = @product.product_options.in_stock.map{|po| po.vehicle_makes}.flatten.uniq
    @vehicle_models = {}
    for vehicle_make in @vehicle_makes
      @vehicle_models[vehicle_make.id] = @product.product_options.in_stock.map{|po| po.product_option_vehicle_models.select{|povm| povm.vehicle_model.vehicle_make_id == vehicle_make.id}}.flatten.uniq.sort{|x,y| x.vehicle_model.name <=> y.vehicle_model.name}
    end
    if !@vehicle_models.keys.any? and @product.product_options.in_stock.length > 1
      @product_options = @product.product_options.in_stock
    end
  end


  private
  def get_product
    if action_name == 'show'
      @product = Product.find(params[:id], 
        :include => [
          :product_images,
          {:product_options => [
            :vehicle_makes,
            {:product_option_vehicle_models => :vehicle_model}
          ]}
        ])
    else
      @product = Product.find(params[:id])
    end
  end
end
