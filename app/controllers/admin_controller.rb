class AdminController < ApplicationController
  
  helper Grundlebox::AdminHelper
  helper Admin::AssetsHelper
  
  # Remember that all admin controllers should inherit from this one. Need to 
  # override things that we want to change!
  
  # Controller setup
  ############################################################################
  
  # All actions will require a valid admin login.
  before_filter :require_admin_login, :except => [:login, :display_404, :display_403, :display_500]
  
  # General prep work
  before_filter :load_defaults
  layout "admin/default"
  
  
  
  # General controller actions
  ############################################################################

  def index
    @articles = (current_user.role.downcase.to_sym==:writer) ? (Article.recently_updated.where(:user_id=>current_user.id)) : (Article.recently_updated)
  end
  
  def help
    render :layout => "admin/wide"
  end
  
  
  
  # Login and logout actions
  ############################################################################
  
  def login
    
    render(:nothing => true, :status => 403) and return if request.xhr?
    
    # Back to the root if we're already logged in
    redirect_to admin_path and return if logged_in?
    
    # Find out what page we're trying to reach
    @next_page = params[:next_page] || session[:next_page] || admin_path

    render :layout => "admin/notice" and return if request.get?

    @user = User.authenticate( params[:email], params[:password] )

    if @user && @user.verified
      @user.update_attribute(:accessed_at, Time::now)
      session[:user_id] = @user.id
      flash[:notice]    = "You have logged in"
      redirect_to @next_page
    else
      flash.now[:error] = "Wrong password or email address"
      render :layout => "admin/notice"
    end

  end
  
  def logout
    session[:user_id] = nil
    flash[:notice] = "You have logged out"
    redirect_to admin_login_path
  end
  
  
  
  
  # Errors
  ############################################################################
  
  # Handle 500 (other) errors, then 404s.
  rescue_from Exception, :with => :display_500
  rescue_from ActiveRecord::RecordNotFound, :with => :display_404
  
  # Custom 404 for admin
  def display_404
    render :nothing => true, :status => 404 and return if request.xhr?
    render :template => "admin/error_404", :status => 404, :layout => "admin/error"
  end
  
  # Custom 403 for admin
  def display_403
    render :nothing => true, :status => 403 and return if request.xhr?
    render :template => "admin/error_403", :status => 403, :layout => "admin/error"
  end
  
  # Custom 500 for admin
  def display_500( e )
    raise e if Rails.env != "production"
    render :nothing => true, :status => 500 and return unless request.format==:html && !request.xhr?
    render :template => "admin/error_500", :status => 500, :layout => "admin/error"
  end
  
  
  # Tools, filters etc.
  ############################################################################
  
  protected 
  
  def send_csv( data, type = :export)
    send_data data.to_csv, :type =>"text/csv", :disposition => 'attachment', 
    :filename => export_filename_for(type, :csv)
  end
  
  
  #
  # Filter out non-admin logins
  #
   
  def require_admin_login
    
    logger.info "\n\n\n######################## User: #{current_user.inspect}"
    # Check the user's timeout
    if current_user && (current_user.accessed_at > (Time::now - Grundlebox::Config::SessionTimeout))
      return is_admin?
    elsif current_user
      flash[:error] = "Your session has timed out"
      session[:user_id] = nil
      session[:next_page] = request.path
      redirect_to admin_login_path and return false
    else
      flash[:error] = "Login to access that page"
      session[:user_id] = nil
      session[:next_page] = request.path
      redirect_to admin_login_path and return false
    end
    
  end
   
  
  #
  # Load some default variables that we'll need in most places
  #
  def load_defaults
    
  end
  
  
  
  #
  # Define the subsections for use in authentication and menus
  #
      
  grundlebox_permissions(
    { :actions => [:index], :roles => [:writer, :editor, :subeditor, :publisher, :admin] },
    { :actions => [:help], :roles => [:writer, :editor, :subeditor, :publisher, :admin] }
  )

  # Allows selected subsection tab to be forced to a particular selection
  def force_subsection( title )
    @forced_active_subsection = title
  end
    
end
