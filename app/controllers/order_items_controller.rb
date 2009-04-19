class OrderItemsController < ApplicationController
  before_filter :get_order_item, :only => [:show,:edit,:update,:destroy]

  def index
    @order_items = OrderItem.find(:all)

  end

  # GET /order_items/1
  # GET /order_items/1.xml
  def show
    render :partial => 'show', :object => @order_item
  end

  # GET /order_items/new
  # GET /order_items/new.xml
  def new
    @order_item = OrderItem.new

    render :partial => 'new', :object => @order_item
  end

  # GET /order_items/1/edit
  def edit
    render :partial => 'edit', :object => @order_item
    
  end

  # POST /order_items
  # POST /order_items.xml
  def create
    @order_item = OrderItem.new(params[:order_item])

    if @order_item.save
      render :partial => 'element_container', :object => @order_item
    else
      render :partial => 'new', :object => @order_item, :status => 409
    end
  end

  # PUT /order_items/1
  # PUT /order_items/1.xml
  def update

    if @order_item.update_attributes(params[:order_item])
      render :partial => 'show', :object => @order_item
    else
      render :partial => 'edit', :object => @order_item, :status => 409
    end
  end

  # DELETE /order_items/1
  # DELETE /order_items/1.xml
  def destroy
    @order_item.destroy

    render :nothing => true
  end

  private
  def get_order_item
    @order_item = OrderItem.find(params[:id])
  end
end
