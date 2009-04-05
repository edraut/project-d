class Manage::ColorGroupsController < Manage::ApplicationController
  before_filter :get_color_group, :only => [:show,:edit,:update,:destroy]

  def index
    @color_groups = ColorGroup.find(:all)

  end

  # GET /manage_color_groups/1
  # GET /manage_color_groups/1.xml
  def show
    render :partial => 'element_container', :object => @color_group
  end

  # GET /manage_color_groups/new
  # GET /manage_color_groups/new.xml
  def new
    @color_group = ColorGroup.new
    @product = Product.find(params[:product_id].to_i) if params.has_key? :product_id

    render :partial => 'new', :object => @color_group
  end

  # GET /manage_color_groups/1/edit
  def edit
    render :partial => 'edit', :object => @color_group
    
  end

  # POST /manage_color_groups
  # POST /manage_color_groups.xml
  def create
    @color_group = ColorGroup.new(params[:color_group])

    if @color_group.save
      flash[:notice] = 'ColorGroup was successfully created.'
      if params[:product_id]
        render :partial => 'select_option', :object => @color_group
      else
        render :partial => 'element_container', :object => @color_group
      end
    else
      render :partial => 'new', :object => @color_group, :status => 409
    end
  end

  # PUT /manage_color_groups/1
  # PUT /manage_color_groups/1.xml
  def update

    if @color_group.update_attributes(params[:color_group])
      flash[:notice] = 'ColorGroup was successfully updated.'
      render :partial => 'show', :object => @color_group
    else
      render :partial => 'edit', :object => @color_group, :status => 409
    end
  end

  # DELETE /manage_color_groups/1
  # DELETE /manage_color_groups/1.xml
  def destroy
    @color_group.destroy

    render :nothing => true
  end

  private
  def get_color_group
    @color_group = ColorGroup.find(params[:id])
  end
end
