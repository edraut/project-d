class Manage::OrdersController < Manage::ApplicationController
  before_filter :get_order, :only => [:show,:edit,:update,:destroy]

  def index
    @orders = Order.send(params[:state]).paginate(:per_page => 25, :page => params[:page])
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
      flash[:notice] = 'Order was successfully updated.'
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
