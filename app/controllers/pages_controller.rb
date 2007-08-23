class PagesController < ApplicationController

  verify :method => :post, :only => [:destroy, :create, :update],
         :add_flash  => { :notice => 'Nur per POST Request möglich' },
         :redirect_to => { :action => :index }


  def index
    @pages = Page.find :all
  end

  def show
    @page = Page.find(params[:id])
  rescue
    render :file => 'public/404.html', :status => 404

  end

  def edit
    @page = Page.find params[:id]
  rescue
    render :file => 'public/404.html', :status => 404
  end

  def update
    @page = Page.find params[:id]
    @page.update_attributes params[:page]
    redirect_to :action => 'index'
  end

  def create
    @page = Page.new(params[:page])
    @page.save
    redirect_to :action => 'index'
  end

  def new
    @page = Page.new
  end

  def destroy
    @page = Page.find params[:id]
    @page.destroy
    redirect_to :action => 'index'
  end
end
