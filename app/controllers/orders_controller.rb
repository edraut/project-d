class OrdersController < ApplicationController
  before_filter :get_order, :only => [:show,:edit,:update,:destroy,:show_coupon_code]

  # GET /orders/1
  # GET /orders/1.xml
  def show
  end

  def show_coupon_code
    render :partial => 'show_coupon_code', :object => @order
  end
  
  private
  def get_order
    @order = Order.find(params[:id])
  end
end
