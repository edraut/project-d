class AddressesController < ApplicationController
  before_filter :get_address, :only => [:show,:edit,:update,:destroy]

  def index
    @addresses = Address.find(:all)

  end

  # GET /addresses/1
  # GET /addresses/1.xml
  def show
    render :partial => 'show', :object => @address
  end

  # GET /addresses/new
  # GET /addresses/new.xml
  def new
    @address = Address.new

    render :partial => 'new', :object => @address
  end

  # GET /addresses/1/edit
  def edit
    render :partial => 'edit', :object => @address
    
  end

  # POST /addresses
  # POST /addresses.xml
  def create
    @address = Address.new(params[:address])

    if @address.save
      flash[:notice] = 'Address was successfully created.'
      render :partial => 'element_container', :object => @address
    else
      render :partial => 'new', :object => @address, :status => 409
    end
  end

  # PUT /addresses/1
  # PUT /addresses/1.xml
  def update
    if @address.update_attributes(params[:address]) and (@address.status == 'live' or @address.user_input)
      flash[:notice] = 'Address was successfully updated.'
      render :partial => 'show', :object => @address
    else
      render :partial => 'edit', :object => @address, :status => 409
    end
  end

  # DELETE /addresses/1
  # DELETE /addresses/1.xml
  def destroy
    @address.destroy

    render :nothing => true
  end

  private
  def get_address
    @address = Address.find(params[:id])
  end
end
