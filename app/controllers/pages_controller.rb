class PagesController < ApplicationController

  layout "referenz"
  
  verify :method => :post, :only => [:destroy, :create, :update],
  :add_flash  => { :notice => 'Nur per POST Request möglich' },
  :redirect_to => { :action => :index }


  def index
    @pages = Page.find :all
    @categories = Category.find :all, :order => "name"
  end

  def show
    @page = Page.find(params[:id])
    @page.increment! :read_counter
  end

  def edit
    @page = Page.find params[:id]

  end

  def update
    @page = Page.find params[:id]
    if @page.update_attributes params[:page]
      redirect_to :action => 'index'
    else
      render :action => "edit"
    end
  end

  def create
    @page = Page.new(params[:page])
    @page.read_counter = 0
    if @page.save
      redirect_to :action => 'index'
    else
      render :action => "new"
    end
  end

  def new
    @page = Page.new
  end

  def destroy
    @page = Page.find params[:id]
    @page.destroy
    redirect_to :action => 'index'
  end
  
  def toggle
    @page = Page.find params[:id]
    @page.toggle! :published
    render :nothing => true
  end
  
end
