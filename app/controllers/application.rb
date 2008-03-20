# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  # Pick a unique cookie name to distinguish our session data from others'
  session :session_key => '_referenz_session_id'
  protect_from_forgery  :secret => 'a27a513a9ea7c44da0cd55caa0b5a30f'
  
  
  rescue_from ActiveRecord::RecordNotFound, :with => :show_404

  def show_404
    render :file => 'public/404.html', :status => 404
  end
  
end
