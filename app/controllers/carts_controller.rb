class CartsController < ApplicationController
  before_filter :get_cart, :only => [:show,:edit,:update,:destroy]

  # GET /carts/1
  # GET /carts/1.xml
  def show
    if params[:get_totals]
      totals_data = {:shipping_total => @cart.shipping_total.format, :total => @cart.total.format, :subtotal => @cart.subtotal.format, :sales_tax => @cart.taxable? ? @cart.sales_tax.format : '$0.00'}
      render :json => totals_data and return
    end
    if params[:stage]
      case params[:stage]
      when 'billing_info'
        @cart.addresses.id_only.clear
        render :template => 'carts/billing_info' and return
      end
    end
  end

  # GET /carts/new

  # PUT /carts/1
  # PUT /carts/1.xml
  def update
    success = true
    if params.has_key? :product_option_vehicle_model_id
      unless @cart.order_items.find(:first, :conditions => {:product_option_vehicle_model_id => params[:product_option_vehicle_model_id].to_i})
        povm = ProductOptionVehicleModel.find(params[:product_option_vehicle_model_id])
        order_item = OrderItem.create(:order_id => @cart.id, :product_option_id => povm.product_option.id, :sku => povm.product_option.sku, :price => povm.product_option.price, :product_option_vehicle_model_id => povm.id, :quantity => 1) || success = false
        @cart.reload
      end
    elsif params.has_key? :order_item
      unless @cart.order_items.find(:first, :conditions => {:product_option_id => params[:order_item][:product_option_id].to_i})
        product_option = ProductOption.find(params[:order_item][:product_option_id].to_i)
        order_item = OrderItem.create(:order_id => @cart.id, :product_option_id => product_option.id, :sku => product_option.sku, :price => product_option.price, :quantity => 1)
        @cart.reload
      end
    elsif params.has_key? :credit_card_number
      gateway = ActiveMerchant::Billing::AuthorizeNetGateway.new(
        :login    => '4MEdAu2X7K',	
        :password => '7nmd9vK4333BHW5u'
      )
      credit_card = ActiveMerchant::Billing::CreditCard.new(
        :number => params[:credit_card_number],
        :first_name => @cart.billing_address.first_name,
        :last_name => @cart.billing_address.last_name,
        :month => params[:credit_card_month],
        :year => params[:credit_card_year],
        :verification_value => params[:credit_card_ccv]
      )
      options = {:address => {}, 
        :billing_address => { 
          :name => @cart.billing_address.full_name,
          :address1 => @cart.billing_address.address_1,
          :city => @cart.billing_address.city,
          :state => @cart.billing_address.state,
          :country => @cart.billing_address.country.iso,
          :zip => @cart.billing_address.zipcode
        }
      }
      response = gateway.purchase(@cart.total, credit_card, options)
      if response.success? or true
        @cart.accept_card
        session[:order_id] = nil
        render :template => 'carts/card_accepted' and return
      else
        @cart.reject_card
        flash[:error] = "The credit card processor rejected the transaction. Here's the reason they gave-- #{response.message}"
        render :template => 'carts/billing_info' and return
      end
    else
      @cart.update_attributes(params[:cart]) || success = false
    end
    if success
      render :template => 'carts/show' and return
    else
      render :template => 'carts/edit' and return
    end
  end

  # DELETE /carts/1
  # DELETE /carts/1.xml
  def destroy
    @cart.destroy
    session[:cart_id] = nil
    redirect_to cart_url
  end

  private
  def get_cart
    @cart = Order.find(:first, :conditions => {:id => session[:cart_id].to_i})
    @cart ||= @this_user.cart if @this_user
    @cart ||= Order.create
    session[:cart_id] = @cart.id
  end
end
