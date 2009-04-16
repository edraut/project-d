class ProductsController < ApplicationController
  before_filter :get_product, :only => [:show,:edit,:update,:destroy]

  def index
    if params[:category_id] or params[:vehicle_make_id]
      sql_joins = []
      sql_where = ["products.state = 'published'"]
      sql_hash = {}
      unless params[:category_id].blank?
        @category = Category.find(params[:category_id].to_i)
        # @vehicle_makes = VehicleMake.find_by_sql(["select distinct(v.*) from vehicle_makes v join product_option_vehicle_makes povma on povma.vehicle_make_id = v.id join product_options po on po.id = povma.product_option_id join products p on p.id = po.product_id join categories c on p.category_id = c.id where p.category_id = :category_id or c.parent_id = :category_id order by v.name",{:category_id => @category.id}])
        @vehicle_makes = VehicleMake.find(:all, :select => "distinct(vehicle_makes.*)", :joins => {:product_option_vehicle_makes => {:product_option => {:product => :category}}}, :conditions => ["categories.id = :category_id or categories.parent_id = :category_id",{:category_id => @category.id}])
        @vehicle_models = {}
        for vehicle_make in @vehicle_makes
          @vehicle_models[vehicle_make.id] = vehicle_make.vehicle_models.find(:all, :select => "distinct(vehicle_models.*)", :joins => {:product_option_vehicle_models => {:product_option => {:product => :category}}}, :conditions => ["categories.id = :category_id or categories.parent_id = :category_id",{:category_id => @category.id}])
          
          # @vehicle_models[vehicle_make.id] = VehicleModel.find_by_sql(["select distinct(v.*) from vehicle_models v join product_option_vehicle_models povm on povm.vehicle_model_id = v.id join product_options po on po.id = povm.product_option_id join products p on p.id = po.product_id join categories c on p.category_id = c.id inner join vehicle_makes vm on vm.id = v.vehicle_make_id where p.category_id = :category_id or c.parent_id = :category_id and vm.id = :vehicle_make_id order by v.name",{:category_id => @category.id, :vehicle_make_id => vehicle_make.id}])
        end
        sql_joins.push "inner join categories cc on products.category_id = cc.id"
        sql_where.push "(products.category_id = :category_id or cc.parent_id = :category_id)"
        sql_hash[:category_id] = @category.id
      end
      if !params[:vehicle_make_id].blank?
        @vehicle_make = VehicleMake.find(params[:vehicle_make_id].to_i)
        if params[:vehicle_model_id].blank?
          sql_joins.push "inner join product_options po on po.product_id = products.id"
          sql_joins.push "inner join product_option_vehicle_makes povm on povm.product_option_id = po.id"
          sql_where.push "(povm.vehicle_make_id = :vehicle_make_id)"
          sql_hash[:vehicle_make_id] = @vehicle_make.id
        end
      end
      unless params[:vehicle_model_id].blank?
        @vehicle_model = VehicleModel.find(params[:vehicle_model_id].to_i)
        sql_joins.push "inner join product_options po on po.product_id = products.id"
        sql_joins.push "inner join product_option_vehicle_models povmo on povmo.product_option_id = po.id"
        sql_where.push "(povmo.vehicle_model_id = :vehicle_model_id)"
        sql_hash[:vehicle_model_id] = @vehicle_model.id
      end
      @products = Product.paginate :joins => sql_joins.join(' '), :conditions => [sql_where.join(' and '),sql_hash], :include => :product_images, :page => params[:page], :per_page => 12
    else
      @products = Product.published.paginate(:per_page => 12, :page => params[:page])
      @nav_tab = 'home'
    end
  end

  # GET /products/1
  # GET /products/1.xml
  def show
    @category = @product.category
    @vehicle_make = VehicleMake.find(params[:vehicle_make_id].to_i) if params[:vehicle_make_id]
    @vehicle_model = VehicleModel.find(params[:vehicle_model_id].to_i) if params[:vehicle_model_id]
    @vehicle_makes = @product.product_options.map{|po| po.vehicle_makes}.flatten.uniq
    @vehicle_models = {}
    for vehicle_make in @vehicle_makes
      @vehicle_models[vehicle_make.id] = @product.product_options.map{|po| po.product_option_vehicle_models.select{|povm| povm.vehicle_model.vehicle_make_id == vehicle_make.id}}.flatten.uniq.sort{|x,y| x.vehicle_model.name <=> y.vehicle_model.name}
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
