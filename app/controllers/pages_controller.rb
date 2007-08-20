class PagesController < ApplicationController

  def index
    @pages = Page.find :all
  end
  
  def show
    @page = Page.find(params[:id])
  end
end
