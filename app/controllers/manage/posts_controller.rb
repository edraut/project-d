class Manage::PostsController < Manage::ApplicationController
  before_filter :get_post, :only => [:show,:edit,:update,:destroy]

  def index
    @posts = Post.find(:all)

  end

  # GET /manage_posts/1
  # GET /manage_posts/1.xml
  def show
  end

  # GET /manage_posts/new
  # GET /manage_posts/new.xml
  def new
    @post = Post.new
  end

  # GET /manage_posts/1/edit
  def edit
  end

  # POST /manage_posts
  # POST /manage_posts.xml
  def create
    @post = Post.new(params[:post])

    if @post.save
      flash[:notice] = 'Post was successfully created.'
      render :template => 'manage/posts/show' and return
    else
      render :template => 'manage/posts/new' and return
    end
  end

  # PUT /manage_posts/1
  # PUT /manage_posts/1.xml
  def update

    if @post.update_attributes(params[:post])
      flash[:notice] = 'Post was successfully updated.'
      render :template => 'manage/posts/show' and return
    else
      render :template => 'manage/posts/edit' and return
    end
  end

  # DELETE /manage_posts/1
  # DELETE /manage_posts/1.xml
  def destroy
    @post.destroy
    @posts = Post.all
    render :template => 'manage/posts/index' and return
  end

  private
  def get_post
    @post = Post.find(params[:id])
  end
end
