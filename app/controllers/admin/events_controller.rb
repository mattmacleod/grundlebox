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
    @events = @events.paginate( :page => params[:page], :per_page => Grundlebox::Config::AdminPaginationLimit )
    if request.xhr?
      render(:partial => "list", :locals => {:events => @events})
      return
    end
  end
 
   
  # Individual events
  ############################################################################
  
  def new
    @event = Event.new
    render :layout => "admin/manual_sidebar"
  end
  
  def create
    @event = Event.new( params[:event] )
    @event.user = current_user
    @event.performances.each{|p| p.user = current_user unless p.user }
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
    @event.performances.each{|p| p.user = current_user unless p.user }
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
  
  
  # Performance builder
  ############################################################################
  
  def build_performances
    @venues = Venue.find(:all)
    
    # Try to generate performances
    if request.post?
      @performance_run = PerformanceRun.new( params[:performance_run] )
      
      # Do some stuffing
      @performance_run.performance.user = User.new
      @performance_run.performance.event = Event.new
      @performance_run.performance.starts_at = Time::now

      @performances = @performance_run.get_performances
      
      # If this is a save, remove any that aren't to be saved
      if params[:commit] == "Create performances"
        @performances.select{|p| params[:performances].values.include?( p.starts_at.to_i.to_s ) }
        render :template => "/admin/events/save_performances", :layout => "admin/iframe"
        return
      end
                 
    else
      @performance_run = PerformanceRun.new( :performance => Performance.new )
    end
    
    render :layout => "admin/iframe"
    
  end
  
  
  
  # Attachment
  ############################################################################
  
  def for_attachment
    @events = Event.order("title ASC").where(["events.title LIKE ?", "%#{params[:q]}%"]).limit( Grundlebox::Config::EventAttachmentLimit )
    render(:partial => "for_attachment", :locals => {:events => @events, :action => :add})
  end
  
end
