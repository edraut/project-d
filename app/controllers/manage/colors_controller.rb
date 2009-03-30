class Manage::ColorsController < Manage::ApplicationController
  before_filter :get_color, :only => [:show,:edit,:update,:destroy]

  def index
    @colors = Color.find(:all)

  end

  # GET /manage_colors/1
  # GET /manage_colors/1.xml
  def show
    render :partial => 'element_container', :object => @color
  end

  # GET /manage_colors/new
  # GET /manage_colors/new.xml
  def new
    @color = Color.new

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
      flash[:notice] = 'Color was successfully created.'
      render :partial => 'element_container', :object => @color
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
