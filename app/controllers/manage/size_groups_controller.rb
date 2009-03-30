class Manage::SizeGroupsController < Manage::ApplicationController
  before_filter :get_size_group, :only => [:show,:edit,:update,:destroy]

  def index
    @size_groups = SizeGroup.find(:all)

  end

  # GET /manage_size_groups/1
  # GET /manage_size_groups/1.xml
  def show
    render :partial => 'element_container', :object => @size_group
  end

  # GET /manage_size_groups/new
  # GET /manage_size_groups/new.xml
  def new
    @size_group = SizeGroup.new
    @product = Product.find(params[:product_id].to_i) if params.has_key? :product_id

    render :partial => 'new', :object => @size_group
  end

  # GET /manage_size_groups/1/edit
  def edit
    render :partial => 'edit', :object => @size_group
    
  end

  # POST /manage_size_groups
  # POST /manage_size_groups.xml
  def create
    @size_group = SizeGroup.new(params[:size_group])

    if @size_group.save
      flash[:notice] = 'SizeGroup was successfully created.'
      if params[:product_id]
        render :partial => 'select_option', :object => @size_group
      else
        render :partial => 'element_container', :object => @size_group
      end
    else
      render :partial => 'new', :object => @size_group, :status => 409
    end
  end

  # PUT /manage_size_groups/1
  # PUT /manage_size_groups/1.xml
  def update

    if @size_group.update_attributes(params[:size_group])
      flash[:notice] = 'SizeGroup was successfully updated.'
      render :partial => 'show', :object => @size_group
    else
      render :partial => 'edit', :object => @size_group, :status => 409
    end
  end

  # DELETE /manage_size_groups/1
  # DELETE /manage_size_groups/1.xml
  def destroy
    @size_group.destroy

    render :nothing => true
  end

  private
  def get_size_group
    @size_group = SizeGroup.find(params[:id])
  end
end
