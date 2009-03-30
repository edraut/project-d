class Manage::SizesController < Manage::ApplicationController
  before_filter :get_size, :only => [:show,:edit,:update,:destroy]

  def index
    @product = Product.find(params[:product_id].to_i) if params[:product_id]
    if params[:size_group_id]
      if params[:size_group_id].to_i > 0
        @size_group = SizeGroup.find(params[:size_group_id].to_i)
        @sizes = @size_group.sizes
      else
        @size_group = nil
        @sizes = []
      end
      
      render :partial => 'select' and return
    else
      @sizes = Size.find(:all)
    end
  end

  # GET /manage_sizes/1
  # GET /manage_sizes/1.xml
  def show
    render :partial => 'element_container', :object => @size
  end

  # GET /manage_sizes/new
  # GET /manage_sizes/new.xml
  def new
    @size = Size.new(params[:size])
    @product = Product.find(params[:product_id].to_i) if params.has_key? :product_id
    render :partial => 'new', :object => @size
  end

  # GET /manage_sizes/1/edit
  def edit
    render :partial => 'edit', :object => @size
    
  end

  # POST /manage_sizes
  # POST /manage_sizes.xml
  def create
    @size = Size.new(params[:size])

    if @size.save
      if params[:product_id]
        render :partial => 'select_option', :object => @size
      else
        flash[:notice] = 'Size was successfully created.'
        render :partial => 'element_container', :object => @size
      end
    else
      render :partial => 'new', :object => @size, :status => 409
    end
  end

  # PUT /manage_sizes/1
  # PUT /manage_sizes/1.xml
  def update

    if @size.update_attributes(params[:size])
      flash[:notice] = 'Size was successfully updated.'
      render :partial => 'show', :object => @size
    else
      render :partial => 'edit', :object => @size, :status => 409
    end
  end

  # DELETE /manage_sizes/1
  # DELETE /manage_sizes/1.xml
  def destroy
    @size.destroy

    render :nothing => true
  end

  private
  def get_size
    @size = Size.find(params[:id])
  end
end
