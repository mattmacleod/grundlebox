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
  
  def attach
    
    # Handle uploads
    if request.post?
      
      if params[:asset]
        
        @url_upload = UrlUpload.new( :asset_folder_id => @current_folder.id )
        
        @asset = Asset.new( params[:asset] )
        @asset.asset = params[:asset][:asset]
        @asset.user = current_user
        if @asset.save
          flash[:notice] = "Your upload has been saved"
          redirect_to use_attach_admin_asset_folders_path( @asset )
          return
        end
        
      elsif params[:url_upload]
      
        @asset = Asset.new( :asset_folder_id => @current_folder.id )
      
        @url_upload = UrlUpload.new( params[:url_upload] )
        @url_upload.user = current_user
        if @url_upload.valid? && @url_upload.convert!
          flash[:notice] = "Upload saved"
          redirect_to use_attach_admin_asset_folders_path( @url_upload.asset )
          return
        end
      
      end
      
    else
      # For uploads
      @asset = Asset.new( :asset_folder_id => @current_folder.id )
      @url_upload = UrlUpload.new( :asset_folder_id => @current_folder.id )
    end
    
    @assets = @current_folder.assets
    @assets = @assets.where(["assets.title LIKE ?", "%#{params[:q]}%"]) if params[:q]
    @assets = @assets.paginate( :page => params[:page], :per_page => 20 )
    

    
    if request.xhr?
      render :partial => "/admin/assets/attachments/folder", :locals => {:assets => @assets}
      return
    end
    render :layout => "admin/iframe"
  end

  def use_attach
    @asset = Asset.find( params[:id] )
    render :layout => "admin/iframe"
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
