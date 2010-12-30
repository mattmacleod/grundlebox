class Admin::AssetFoldersController < AdminController
  
  # Define controller subsections
  def self.subsections
    [
      { :title => :browse, :actions => [:index, :show, :new, :create, :edit, :destroy, :update, :browse], :roles => [:admin, :publisher, :subeditor] }
    ]
  end
  build_permissions
  
  before_filter :load_folder
  
  def index
    if( params[:path].to_s.split("/") == @current_folder.path )
      @assets = @current_folder.assets
      @assets = @assets.where(["assets.title LIKE ?", "%#{params[:q]}%"]) if params[:q]
      @assets = @assets.paginate( :page => params[:page], :per_page => 20 )
      if request.xhr?
        render(:partial => "folder", :locals => {:assets => @assets})
        return
      end
    else
      redirect_to browse_admin_asset_folders_path( @current_folder.path )
    end
  end

  def show
    redirect_to browse_admin_asset_folders_path(@current_folder.path)
  end
  
  def new
    @asset_folder = AssetFolder.new( :parent_id => @current_folder.id )
    @asset_folder.parent = @current_folder
    
    respond_to do |format|
      format.html do
        render :layout => "admin/manual_sidebar"
      end
      format.js do
        render :layout => "admin/lightbox"
      end
    end
    
  end
  
  def create
    @asset_folder = AssetFolder.new( params[:asset_folder] )
    @asset_folder.parent_id = params[:asset_folder][:parent_id]
    if @asset_folder.save
      flash[:notice] = "Your folder has been saved"
      respond_to do |format|
        format.html do
          redirect_to browse_admin_asset_folders_path( @asset_folder.path )        
        end
        format.js do
          @reload = true
          render :partial => "admin/components/lightbox/close"
        end
      end
    else
      respond_to do |format|
        format.html do
          render :action => :new, :layout => "admin/manual_sidebar"
        end
        format.js do
          render :action => :new, :layout => "admin/lightbox"
        end
      end
    end
  end
  
  def edit
    @asset_folder = AssetFolder.find( params[:id] )
    render :layout => "admin/manual_sidebar"
  end
  
  def update
    @asset_folder = AssetFolder.find( params[:id] )
    @asset_folder.attributes = params[:asset_folder]
    @asset_folder.parent_id = params[:asset_folder][:parent_id]
    if @asset_folder.save
      flash[:notice] = "Changes saved"
      redirect_to browse_admin_asset_folders_path( @asset_folder.path )
    else
      render :action => :edit, :layout => "admin/manual_sidebar" and return
    end
  end
  
  def destroy
    @asset_folder = AssetFolder.find(params[:id])
    if @asset_folder.parent && @asset_folder.destroy
      flash[:notice] = "Asset folder removed"
      redirect_to browse_admin_asset_folders_path( @asset_folder.parent.path ) and return
    else
      flash[:error] = "Delete failed"
      redirect_to :action => :index and return
    end
  end
  
  
  
  ############################################################################
  # Attachments
  ############################################################################
  
  def browse_for_attach
    @assets = @current_folder.assets
    @assets = @assets.where(["assets.title LIKE ?", "%#{params[:q]}%"]) if params[:q]
    @assets = @assets.paginate(:page => params[:page])
    if request.xhr?
      render :partial => "folder_for_attach", :locals => {:assets => @assets}
      return
    end
    render :layout => "admin/iframe"
  end
  
  def attachment_form
    @asset = Asset.find( params[:id] )
    render :partial => "attachment_form", :locals => {:asset => @asset, :field_name => params[:field_name]}
  end
  
  
  
  ############################################################################
  # Private helper methods
  ############################################################################
  
  private
  
  def load_folder
    @current_folder = AssetFolder.where(:id => params[:path].to_s.split("/").last.to_s.split("-").first).first
    @current_folder ||= AssetFolder.where(:id => session[:current_folder]).first
    @current_folder ||= AssetFolder.root
    session[:current_folder] = @current_folder.id
  end
  
  
end
