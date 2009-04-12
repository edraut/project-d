class CartsController < ApplicationController
  before_filter :get_cart, :only => [:show,:edit,:update,:destroy]

  def index
    @carts = Cart.find(:all)

  end

  # GET /carts/1
  # GET /carts/1.xml
  def show
  end

  # GET /carts/new
  # GET /carts/new.xml
  def new
    @cart = Cart.new
  end

  # GET /carts/1/edit
  def edit
  end

  # POST /carts
  # POST /carts.xml
  def create
    @cart = Cart.new(params[:cart])

    if @cart.save
      flash[:notice] = 'Cart was successfully created.'
      render :template => 'carts/show' and return
    else
      render :template => 'carts/new' and return
    end
  end

  # PUT /carts/1
  # PUT /carts/1.xml
  def update

    if @cart.update_attributes(params[:cart])
      flash[:notice] = 'Cart was successfully updated.'
      render :template => 'carts/show' and return
    else
      render :template => 'carts/edit' and return
    end
  end

  # DELETE /carts/1
  # DELETE /carts/1.xml
  def destroy
    @cart.destroy
    @carts = Cart.all
    render :template => 'carts/index' and return
  end

  protected
  def set_nav_tab
    @nav_tab = 'cart'
  end
  
  private
  def get_cart
    @cart = Cart.get_by_session_or_user
  end
end
