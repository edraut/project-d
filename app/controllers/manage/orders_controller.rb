class Manage::OrdersController < Manage::ApplicationController
  before_filter :get_order, :only => [:show,:edit,:update,:destroy]

  def index
    if params[:search_terms]
      @orders = Order.paginate_by_sql(["select distinct(orders.*) from orders inner join addresses on addresses.order_id = orders.id where orders.id = :search_term or lower(addresses.last_name) like lower(:search_term_fuzzy)",{:search_term => params[:search_terms].to_i, :search_term_fuzzy => "%#{params[:search_terms]}%"}], :per_page => 25, :page => params[:page])
    else
      @orders = Order.send(params[:state]).paginate(:per_page => 25, :page => params[:page])
    end
    @state = params[:state]
  end

  # GET /manage_orders/1
  # GET /manage_orders/1.xml
  def show
    if params.has_key? :version
      case params[:version]
      when 'full'
        render :template => 'manage/orders/show_full' and return
      end
    end
    render :partial => 'show', :object => @order
  end

  # GET /manage_orders/new
  # GET /manage_orders/new.xml
  def new
    @order = Order.new

    render :partial => 'new', :object => @order
  end

  # GET /manage_orders/1/edit
  def edit
    render :partial => 'edit', :object => @order
    
  end

  # POST /manage_orders
  # POST /manage_orders.xml
  def create
    @order = Order.new(params[:order])

    if @order.save
      flash[:notice] = 'Order was successfully created.'
      render :partial => 'element_container', :object => @order
    else
      render :partial => 'new', :object => @order, :status => 409
    end
  end

  # PUT /manage_orders/1
  # PUT /manage_orders/1.xml
  def update
    if params.has_key? :event
      @order.send(params[:event])
      redirect_to manage_orders_url + '?state=pending' and return
    end
    if @order.update_attributes(params[:order])
      render :partial => 'show', :object => @order
    else
      render :partial => 'edit', :object => @order, :status => 409
    end
  end

  # DELETE /manage_orders/1
  # DELETE /manage_orders/1.xml
  def destroy
    @order.destroy

    render :nothing => true
  end

  private
  def get_order
    @order = Order.find(params[:id])
  end
end
