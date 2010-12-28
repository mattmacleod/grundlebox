class Admin::TagsController < AdminController
  
  layout "admin/wide"
  
  # Define controller subsections
  def self.subsections
    [
      { :title => :tags, :actions => [:index, :show, :edit, :update, :new, :create], :roles => [:admin] }
    ]
  end
  build_permissions
  
  
  # Tag management
  ############################################################################
  
  def index
    
    @tags ||= Tag.popular

    # Filters
    @tags = @tags.where(["tags.name LIKE ?", "%#{params[:q]}%"]) if params[:q]
        
    respond_to do |format|
      format.js do
        @tags = @tags.includes(:taggings).paginate(:page => params[:page])
        render :partial => "list", :locals => {:tags => @tags}
        return
      end
      format.html do
        @tags = @tags.includes(:taggings).paginate(:page => params[:page])
        render :action => "index"
        return
      end
      format.json do
        @tags = @tags.limit(10).all
        render :json => @tags.to_json
        return
      end
    end
    
  end

  def show
    @tag = Tag.find( params[:id] )
    render :layout => "admin/manual_sidebar"
  end
  
  def edit
    redirect_to admin_tags_path
  end
  
  def create
    redirect_to admin_tags_path
  end
  
  def update
    redirect_to admin_tags_path
  end
  
  def new
    redirect_to admin_tags_path
  end
  
  def destroy
    @tag = Tag.find(params[:id])
    @tag.destroy
    flash[:notice] = "Tag deleted"
    redirect_to admin_tags_path
  end
  
end
