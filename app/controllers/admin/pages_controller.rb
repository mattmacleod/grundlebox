class Admin::PagesController < AdminController
  
  # Define controller subsections
  def self.subsections
    [
      { :title => :page_manager, :actions => [:index, :show, :edit, :update, :new, :create], :roles => [:admin, :publisher] }
    ]
  end
  build_permissions
  
  # Lists
  ############################################################################
  
  def index
    @pages = Page.nodes.compact
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
  end
  

end
