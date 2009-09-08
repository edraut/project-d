class Manage::CouponsController < Manage::ApplicationController
  before_filter :get_coupon, :only => [:show,:edit,:update,:destroy]
  before_filter :prepare_params, :only => [:create,:update]
  before_filter :manage_money, :only => [:create,:update]

  def index
    @coupons = Coupon.find(:all)

  end

  # GET /manage_coupons/1
  # GET /manage_coupons/1.xml
  def show
    render :partial => 'show', :object => @coupon
  end

  # GET /manage_coupons/new
  # GET /manage_coupons/new.xml
  def new
    @coupon = Coupon.new

    render :partial => 'new', :object => @coupon
  end

  # GET /manage_coupons/1/edit
  def edit
    render :partial => 'edit', :object => @coupon
    
  end

  # POST /manage_coupons
  # POST /manage_coupons.xml
  def create
    @coupon = Coupon.new(@editable_params)

    if @coupon.save
      flash[:notice] = 'Coupon was successfully created.'
      render :partial => 'element_container', :object => @coupon
    else
      render :partial => 'new', :object => @coupon, :status => 409
    end
  end

  # PUT /manage_coupons/1
  # PUT /manage_coupons/1.xml
  def update

    if @coupon.update_attributes(@editable_params)
      flash[:notice] = 'Coupon was successfully updated.'
      render :partial => 'show', :object => @coupon
    else
      render :partial => 'edit', :object => @coupon, :status => 409
    end
  end

  # DELETE /manage_coupons/1
  # DELETE /manage_coupons/1.xml
  def destroy
    @coupon.destroy

    render :nothing => true
  end

  private
  def prepare_params
    @editable_params = params[:coupon].dup
    @money_attributes = [:flat_amount]
  end
  def get_coupon
    @coupon = Coupon.find(params[:id])
  end
end
