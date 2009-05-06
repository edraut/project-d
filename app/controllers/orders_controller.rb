class OrdersController < ApplicationController
  before_filter :get_order, :only => [:show,:edit,:update,:destroy]

  # GET /orders/1
  # GET /orders/1.xml
  def show
  end

  private
  def get_order
    @order = Order.find(params[:id])
  end
end
