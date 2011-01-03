class Admin::EventsController < AdminController
  
  # Define controller subsections
  def self.subsections
    [
      { :title => :all_events, :actions => [:index, :show, :edit, :update, :new, :create], :roles => [:admin, :publisher] }
    ]
  end
  build_permissions
  
  # Lists
  ############################################################################
  
  def index
    @events = Event.order("title ASC")
    @events = @events.where(["events.title LIKE ?", "%#{params[:q]}%"]) if params[:q]
    @events = @events.paginate( :page => params[:page], :per_page => 20 )
    if request.xhr?
      render(:partial => "list", :locals => {:events => @events})
      return
    end
  end
 
   
  # Individual users
  ############################################################################
  
  def new
    @event = Event.new
    render :layout => "admin/manual_sidebar"
  end
  
  def create
    @event = Event.new( params[:event] )
    @event.user = current_user
    if @event.save
      flash[:notice] = "Event has been created"
      redirect_to( :action=>:index )
    else
      render( :action=>:new, :layout => "admin/manual_sidebar" )
    end
  end
  
  def show
    redirect_to :action => :edit 
  end
  
  def edit
    @event = Event.find( params[:id] )
    render( :layout => "admin/manual_sidebar" )
  end
  
  def update
    @event = Event.find( params[:id] )
    @event.attributes = params[:event]
    if @event.save
      flash[:notice] = "Event has been saved"
      redirect_to( :action => :index )
    else
      render( :action => :edit, :layout => "admin/manual_sidebar" )
    end
  end
  
  def destroy
    @event = Event.find( params[:id] )
    if @event.destroy
      flash[:notice] = "Event deleted"
    end
    redirect_to :action => :index
  end
  
end
