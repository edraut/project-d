class Manage::ProductOptionsController < Manage::ApplicationController
  before_filter :get_product_option, :only => [:show,:edit,:update,:destroy]
  before_filter :prepare_params, :only => [:create,:update]
  before_filter :manage_money, :only => [:create,:update]

  def index
    @product_options = ProductOption.find(:all)

  end

  # GET /manage_product_options/1
  # GET /manage_product_options/1.xml
  def show
    if params.has_key? :product_option_section
      case params[:product_option_section]
      when 'models'
        render :partial => 'models', :object => @product_option and return
      end
    end
    render :partial => 'show', :object => @product_option
  end

  # GET /manage_product_options/new
  # GET /manage_product_options/new.xml
  def new
    @product_option = ProductOption.new

    render :partial => 'new', :object => @product_option
  end

  # GET /manage_product_options/1/edit
  def edit
    render :partial => 'edit', :object => @product_option
    
  end

  # POST /manage_product_options
  # POST /manage_product_options.xml
  def create
    @product_option = ProductOption.new(@editable_params)

    if @product_option.save
      flash[:notice] = 'ProductOption was successfully created.'
      render :partial => 'element_container', :object => @product_option
    else
      render :partial => 'new', :object => @product_option, :status => 409
    end
  end

  # PUT /manage_product_options/1
  # PUT /manage_product_options/1.xml
  def update
    if params[:id] == 'multiple'
      @product_options.each do |product_option|
        product_option.position = params[:product_option].index(product_option.id.to_s)
        product_option.save
      end
      render :nothing => true and return
    end
    if @product_option.update_attributes(@editable_params)
      flash[:notice] = 'ProductOption was successfully updated.'
      render :partial => 'show', :object => @product_option
    else
      render :partial => 'edit', :object => @product_option, :status => 409
    end
  end

  # DELETE /manage_product_options/1
  # DELETE /manage_product_options/1.xml
  def destroy
    @product_option.destroy

    render :nothing => true
  end

  private
  def prepare_params
    @editable_params = params[:product_option].dup
    @money_attributes = [:price]
  end
  def get_product_option
    if params[:id] == 'multiple'
      @product_options = ProductOption.find(params[:product_option])
    else
      @product_option = ProductOption.find(params[:id])
    end
  end
end
