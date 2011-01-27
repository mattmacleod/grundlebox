class Admin::PagesController < AdminController
  
  # Define controller subsections
  grundlebox_permissions(
    { :actions => [:index, :show, :edit, :update, :new, :create], :roles => [:admin, :publisher] }
  )
  
  # Lists
  ############################################################################
  
  def index
    @root = Page.root
    @recent_pages = Page.order( "updated_at DESC" ).limit(10)
  end
 
   
  # Individual pages
  ############################################################################
  
  def new
    @page = Page.new
    
    # Some defaults
    @page.page_type = "text"
    @page.menu = Menu.first
    @page.parent_id = params[:parent_id]
    
    render :layout => "admin/manual_sidebar"
    
  end
  
  def create
    @page = Page.new( params[:page] )
    @page.user = current_user
    @page.menu = Menu.first #TODO
    if @page.save
      flash[:notice] = "Page has been created"
      redirect_to( :action=>:index )
    else
      render( :action=>:new, :layout => "admin/manual_sidebar" )
    end
  end
  
  def show
    redirect_to :action => :edit 
  end
  
  def edit
    @page = Page.find( params[:id] )
    render( :layout => "admin/manual_sidebar" )
  end
  
  def update
    @page = Page.find( params[:id] )
    @page.attributes = params[:page]
    if @page.save
      flash[:notice] = "Page has been saved"
      redirect_to( :action => :index )
    else
      render( :action => :edit, :layout => "admin/manual_sidebar" )
    end
  end
  
  def destroy
    @page = Page.find( params[:id] )
    if @page.destroy
      flash[:notice] = "Page deleted"
    end
    redirect_to :action => :index
  end
  
  
  # Reordering
  ############################################################################
  
  def update_order
    
    # Preload root node
    @root = Page.root
    
    # Update the parent of the page
    @page = Page.find( params[:m] )
    @page.parent_id = params[:p]
    
    # Save the page
    if @page.save
      # It saved, so update the sort order en masse
      params[:s].each_with_index do |id,idx|
        Page.find( id ).update_attribute(:sort_order, idx) rescue nil
      end
      
      # Reload the node cache
      Page.clear_nodes
      
      render :partial => "list", :status => 200, :locals => { :root => @root }
      
    else
      # Save failed, don't touch the sort orders
      render :partial => "list", :status => 409, :locals => { :root => @root }
    end
    
  end
  

end
