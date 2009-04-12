class ProductsController < ApplicationController
  before_filter :get_product, :only => [:show,:edit,:update,:destroy]

  def index
    if params[:category_id] or params[:vehicle_make_id]
      sql_joins = []
      sql_where = ["p.state = 'published'"]
      sql_hash = {}
      unless params[:category_id].blank?
        @category = Category.find(params[:category_id].to_i)
        sql_joins.push "inner join categories cc on p.category_id = cc.id"
        sql_where.push "(p.category_id = :category_id or cc.parent_id = :category_id)"
        sql_hash[:category_id] = @category.id
      end
      if !params[:vehicle_make_id].blank?
        @vehicle_make = VehicleMake.find(params[:vehicle_make_id].to_i)
        if params[:vehicle_model_id].blank?
          sql_joins.push "inner join product_options po on po.product_id = p.id"
          sql_joins.push "inner join product_option_vehicle_makes povm on povm.product_option_id = po.id"
          sql_where.push "(povm.vehicle_make_id = :vehicle_make_id)"
          sql_hash[:vehicle_make_id] = @vehicle_make.id
        end
      end
      unless params[:vehicle_model_id].blank?
        @vehicle_model = VehicleModel.find(params[:vehicle_model_id].to_i)
        sql_joins.push "inner join product_options po on po.product_id = p.id"
        sql_joins.push "inner join product_option_vehicle_models povmo on povmo.product_option_id = po.id"
        sql_where.push "(povmo.vehicle_model_id = :vehicle_model_id)"
        sql_hash[:vehicle_model_id] = @vehicle_model.id
      end
      @products = Product.paginate_by_sql ["select p.* from products p #{sql_joins.join(' ')} where #{sql_where.join(' and ')} ",sql_hash], :page => params[:page], :per_page => 8
    else
      @products = Product.published.paginate(:per_page => 8, :page => params[:page])
      @nav_tab = 'home'
    end
  end

  # GET /products/1
  # GET /products/1.xml
  def show
  end


  private
  def get_product
    @product = Product.find(params[:id])
  end
end
