class Manage::CategoriesController < Manage::ApplicationController
  before_filter :get_category, :only => [:show,:edit,:update,:destroy]

  def index
    if params[:parent_id]
      if params[:parent_id].to_i > 0
        @parent = Category.find(params[:parent_id].to_i)
        @categories = @parent.children
      else
        @parent = nil
        @categories = []
      end
      if params[:owner_type]
        @owner_class = params[:owner_type].constantize
        @owner_class_name = @owner_class.name
        @owner = @owner_class.find(params[:owner_id]) if params[:owner_id]
      end
      render :partial => params[:ui_element] and return
    else
      @categories = Category.find(:all)
    end
  end

  # GET /manage_categories/1
  # GET /manage_categories/1.xml
  def show
    render :partial => 'element_container', :object => @category
  end

  # GET /manage_categories/new
  # GET /manage_categories/new.xml
  def new
    if params[:parent_id]
      @parent = Category.find(params[:parent_id])
      @category = Category.new(:parent_id => @parent.id)
    else
      @category = Category.new
    end
    if params[:ui_element]
      @ui_element = params[:ui_element]
      render :partial => 'new_ui_element', :object => @category
    else
      render :partial => 'new', :object => @category
    end
  end

  # GET /manage_categories/1/edit
  def edit
    render :partial => 'edit', :object => @category
    
  end

  # POST /manage_categories
  # POST /manage_categories.xml
  def create
    @category = Category.new(params[:category])
    if @category.save
      flash[:notice] = 'Category was successfully created.'
      if params[:ui_element]
        render :partial => params[:ui_element] + '_tag', :object => @category
      else
        render :partial => 'element_container', :object => @category
      end
    else
      render :partial => 'new', :object => @category, :status => 409
    end
  end

  # PUT /manage_categories/1
  # PUT /manage_categories/1.xml
  def update

    if @category.update_attributes(params[:category])
      flash[:notice] = 'Category was successfully updated.'
      render :partial => 'show', :object => @category
    else
      render :partial => 'edit', :object => @category, :status => 409
    end
  end

  # DELETE /manage_categories/1
  # DELETE /manage_categories/1.xml
  def destroy
    @category.destroy

    render :nothing => true
  end

  private
  def get_category
    @category = Category.find(params[:id])
  end
end
