class Admin::AssetsController < AdminController
  
  # Define controller subsections
  def self.subsections
    [
      { :title => :browse, :actions => [:index, :show, :new, :create, :edit, :destroy, :update, :browse], :roles => [:admin, :publisher, :subeditor] }
    ]
  end
  build_permissions
  
  before_filter :load_folder
  
  def index
    redirect_to admin_asset_folders_path
  end
  
  def show
    redirect_to edit_admin_asset_path(params[:id])
  end
  
  def new
    @asset = Asset.new( :asset_folder_id => @current_folder.id )
    render :layout => "admin/manual_sidebar"
  end
  
  def create
    @asset = Asset.new( params[:asset] )
    @asset.asset = params[:asset][:asset]
    @asset.user = current_user
    if @asset.save
      flash[:notice] = "Your upload has been saved"
      redirect_to browse_admin_asset_folders_path( @asset.asset_folder.path )
    else
      render :action => :new, :layout => "admin/manual_sidebar" and return
    end
  end
  
  def edit
    @asset = Asset.find( params[:id] )
    render :layout => "admin/manual_sidebar"
  end
  
  def update
    @asset = Asset.find( params[:id] )
    @asset.attributes = params[:asset]
    @asset.asset = params[:asset][:asset] unless params[:asset][:asset].nil?
    if @asset.save
      flash[:notice] = "Changes saved"
      redirect_to browse_admin_asset_folders_path( @asset.asset_folder.path )
    else
      render :action => :edit, :layout => "admin/manual_sidebar" and return
    end
  end
  
  def destroy
    @asset = Asset.find(params[:id])
    if @asset.destroy
      flash[:notice] = "Asset removed"
    end
    redirect_to browse_admin_asset_folders_path( @asset.asset_folder.path ) and return
  end
  
  
  ############################################################################
  # Private helper methods
  ############################################################################
  
  private
  
  def load_folder
    @current_folder = AssetFolder.where(:id => params[:path].to_s.split("/").last.to_s.split("-")).first
    @current_folder ||= AssetFolder.where(:id => session[:current_folder]).first
    @current_folder ||= AssetFolder.root
    session[:current_folder] = @current_folder.id
  end
  
end