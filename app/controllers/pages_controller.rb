class PagesController < ApplicationController

  def index
    @pages = Page.find :all
  end

  def show
    @page = Page.find(params[:id])
  rescue
    render :file => 'public/404.html', :status => 404

  end
  
  def list
    @pages = Page.find :all
  end
  
end
