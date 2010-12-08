class AdminController < ApplicationController
  
  # Remember that all admin controllers should inherit from this one. Need to 
  # override things that we want to change!
  
  # Controller setup
  ############################################################################
  
  # All actions will require a valid admin login.
  before_filter :require_admin_login, :except => :login
  
  # Layout will be overriden for #login and #denied
  layout "admin/default"
  
  # Handle 404 errors
  rescue_from ActiveRecord::RecordNotFound, :with => :display_404
  
  
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
    @next_page = params[:next_page] || admin_path

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
  
  def denied
    render :layout => "admin/notice"
  end
  
  
  # Other admin tools
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
    
    # Check the user's timeout
    if current_user && (current_user.accessed_at > (Time::now - Grundlebox::Config::SessionTimeout))
      return true if is_admin?
    elsif current_user
      flash[:error] = "Your session has timed out"
      session[:user_id] = nil
      redirect_to admin_login_path and return false
    else
      flash[:error] = "Login to access that page"
      session[:user_id] = nil
      redirect_to admin_login_path and return false
    end
    
  end
   
  
  #
  # Define the subsections for use in authentication and menus
  #
      
  def self.subsections
    [
      { :title => :summary, :actions => [:index], :roles => [:writer, :editor, :subeditor, :publisher, :admin] },
      { :title => :help, :actions => [:help], :roles => [:writer, :editor, :subeditor, :publisher, :admin] }
    ]
  end

  # Allows selected subsection tab to be forced to a particular selection
  def force_subsection( title )
    @forced_active_subsection = title
  end
  
  build_permissions
  
end
