class ApplicationController < ActionController::Base
  protect_from_forgery
    
  # General-use error handlers
  ############################################################################
  
  def display_404
    render "/public/404.html", :status => 404, :layout => false
  end
  
  protected
  
  # User login methods
  ############################################################################
  
  helper_method :current_user, :logged_in?, :is_admin?
  
  def current_user
    return @current_user if @current_user
    if session[:user_id]
      @current_user = User.find( :first, :conditions=>{:id => session[:user_id]} ) 
      if (!@current_user.accessed_at || (@current_user.accessed_at > (Time::now - Grundlebox::Config::SessionTimeout)))
        @current_user.update_attribute(:accessed_at, Time::now)
      end
      return @current_user
    end
  end
  
  def logged_in?
    !!current_user
  end
  
  def is_admin?
    logged_in? && Grundlebox::Config::AdminRoles.include?( current_user.role )
  end
  
  # Put together a nice export filename
  def export_filename_for( type = :export, extension = :csv )
    return "#{ type }_#{ Time::now.strftime("%Y%m%d%H%M%S") }.#{extension}"
  end
  
end
