class NewsController < ApplicationController
  before_filter :get_news, :only => [:show,:edit,:update,:destroy]

  def index
    # @news = News.find(:all)

  end

  # GET /news/1
  # GET /news/1.xml
  def show
  end

  private
  def get_news
    @news = News.find(params[:id])
  end
end
