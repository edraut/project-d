class Manage::ColorsController < Manage::ApplicationController
  before_filter :get_color, :only => [:show,:edit,:update,:destroy]

  def index
    @product = Product.find(params[:product_id].to_i) if params[:product_id]
    if params[:color_group_id]
      if params[:color_group_id].to_i > 0
        @color_group = ColorGroup.find(params[:color_group_id].to_i)
        @colors = @color_group.colors
      else
        @color_group = nil
        @colors = []
      end
      
      render :partial => 'select' and return
    else
      @colors = Color.find(:all)
    end
  end

  # GET /manage_colors/1
  # GET /manage_colors/1.xml
  def show
    render :partial => 'element_container', :object => @color
  end

  # GET /manage_colors/new
  # GET /manage_colors/new.xml
  def new
    @color = Color.new(params[:color])
    @product = Product.find(params[:product_id].to_i) if params.has_key? :product_id
    render :partial => 'new', :object => @color
  end

  # GET /manage_colors/1/edit
  def edit
    render :partial => 'edit', :object => @color
    
  end

  # POST /manage_colors
  # POST /manage_colors.xml
  def create
    @color = Color.new(params[:color])

    if @color.save
      if params[:product_id]
        render :partial => 'select_option', :object => @color
      else
        flash[:notice] = 'Color was successfully created.'
        render :partial => 'element_container', :object => @color
      end
    else
      render :partial => 'new', :object => @color, :status => 409
    end
  end

  # PUT /manage_colors/1
  # PUT /manage_colors/1.xml
  def update

    if @color.update_attributes(params[:color])
      flash[:notice] = 'Color was successfully updated.'
      render :partial => 'show', :object => @color
    else
      render :partial => 'edit', :object => @color, :status => 409
    end
  end

  # DELETE /manage_colors/1
  # DELETE /manage_colors/1.xml
  def destroy
    @color.destroy

    render :nothing => true
  end

  private
  def get_color
    @color = Color.find(params[:id])
  end
end
