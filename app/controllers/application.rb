# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  before_filter :set_nav_area
  before_filter :set_nav_tab
  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  # protect_from_forgery # :secret => '43c771a06b224b59eadad4cc84ca056e'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password
  def string_to_money(string)
    Money.new(string.to_f * 100)
  end
  
  def manage_money
    if @editable_params and @editable_params.is_a? Hash
      for money_attribute in @money_attributes
        @editable_params[money_attribute] = string_to_money(@editable_params[money_attribute])
      end
    end
  end
  
  def prepare_products(limit)
    if params[:search_terms]
      product_vectors = ProductVector.find_by_tsearch(params[:search_terms], :limit => 128)
      vehicle_models = VehicleModel.find_by_tsearch(params[:search_terms], :include => {:product_option_vehicle_models => :product_option}, :limit => 128)
      product_ids = product_vectors.map{|pv| pv.product_id} + vehicle_models.map{|vm| vm.product_option_vehicle_models.map{|povm| povm.product_option.product_id}}.flatten
      if product_ids.any?
        @products = Product.paginate(product_ids.uniq, :per_page => limit, :page => params[:page])
      else
        @products = Product.paginate(:per_page => limit, :page => params[:page], :order => 'random()', :limit => 128)
      end
    else
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
        @products = Product.paginate :joins => sql_joins.join(' '), :conditions => [sql_where.join(' and '),sql_hash], :include => :product_images, :page => params[:page], :per_page => limit, :order => 'product_images.position'
      else
        @products = Product.published.paginate(:per_page => limit, :page => params[:page])
      end
    end
  end
  
  def set_nav_area
    @nav_area = 'public'
  end
  def set_nav_tab
    @nav_tab = controller_name
  end
end
