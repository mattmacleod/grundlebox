class Admin::VenuesController < AdminController
  
  # Define controller subsections
  def self.subsections
    [
      { :title => :all_venues, :actions => [:index, :show, :edit, :update, :new, :create], :roles => [:admin, :publisher] }
    ]
  end
  build_permissions
  
  # Lists
  ############################################################################
  
  def index
    @venues = Venue.order("title ASC")
    @venues = @venues.where(["venues.title LIKE ?", "%#{params[:q]}%"]) if params[:q]
    @venues = @venues.paginate( :page => params[:page], :per_page => 20 )
    if request.xhr?
      render(:partial => "list", :locals => {:venues => @venues})
      return
    end
  end
 
   
  # Individual users
  ############################################################################
  
  def new
    @venue = Venue.new
    render :layout => "admin/manual_sidebar"
  end
  
  def create
    @venue = Venue.new( params[:venue] )
    @venue.user = current_user
    if @venue.save
      flash[:notice] = "Venue has been created"
      redirect_to( :action=>:index )
    else
      render( :action=>:new, :layout => "admin/manual_sidebar" )
    end
  end
  
  def show
    redirect_to :action => :edit 
  end
  
  def edit
    @venue = Venue.find( params[:id] )
    render( :layout => "admin/manual_sidebar" )
  end
  
  def update
    @venue = Venue.find( params[:id] )
    @venue.attributes = params[:venue]
    if @venue.save
      flash[:notice] = "Venue has been saved"
      redirect_to( :action => :index )
    else
      render( :action => :edit, :layout => "admin/manual_sidebar" )
    end
  end
  
  def destroy
    @venue = Venue.find( params[:id] )
    if @venue.destroy
      flash[:notice] = "Venue deleted"
    end
    redirect_to :action => :index
  end
  
end
