class Manage::ProductImagesController < Manage::ApplicationController
  before_filter :get_product_image, :only => [:show,:edit,:update,:destroy]
  before_filter :get_product, :only => [:create]
  def index
    @product_images = ProductImage.find(:all)

  end

  # GET /manage_product_images/1
  # GET /manage_product_images/1.xml
  def show
    @product = @product_image.product
    render :partial => 'show', :object => @product_image
  end

  # GET /manage_product_images/new
  # GET /manage_product_images/new.xml
  def new
    @product_image = ProductImage.new

    render :partial => 'new', :object => @product_image
  end

  # GET /manage_product_images/1/edit
  def edit
    render :partial => 'edit', :object => @product_image
    
  end

  # POST /manage_product_images
  # POST /manage_product_images.xml
  def create
    position = @product.product_images.any? ? @product.product_images.maximum(:position) + 1 : 1
    @product_image = ProductImage.new(params[:product_image].merge(:position => position))
    @product = @product_image.product
    success = true
    if @product_image.save
      @rendered_image = render_to_string :partial => 'element_container', :object => @product_image, :locals => {:row_end => ((@product.product_images.index(@product_image) % 2) == 1) }
      @rendered_image.gsub!(/(\\|<\/|\r\n|[\n\r"'])/) { ActionView::Helpers::JavaScriptHelper::JS_ESCAPE_MAP[$1] }
    else
      success = false
    end
    responds_to_parent do
      if success
        render :update do |page|
          page << '$("#product_image_list").append("' + @rendered_image + '");'
          page << "bindAjaxEvents();$('#product_image_uploading').hide();$('#image_ready').show();"
        end
      else
        render :partial => 'new'
      end
    end
  end

  # PUT /manage_product_images/1
  # PUT /manage_product_images/1.xml
  def update

    if @product_image.update_attributes(params[:product_image])
      flash[:notice] = 'ProductImage was successfully updated.'
      render :partial => 'show', :object => @product_image
    else
      render :partial => 'edit', :object => @product_image, :status => 409
    end
  end

  # DELETE /manage_product_images/1
  # DELETE /manage_product_images/1.xml
  def destroy
    @product = @product_image.product
    @product_image.destroy
    @product.reload
    render :partial => "plain_index", :object => @product and return
  end

  private
  def get_product
    @product ||= Product.find(params[:product_image][:product_id])
  end
  
  def get_product_image
    @product_image = ProductImage.find(params[:id])
  end
end
