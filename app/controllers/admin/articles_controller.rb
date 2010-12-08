class Admin::ArticlesController < AdminController
    
  before_filter :get_article, :only => [:edit, :update, :destroy, :unpublish, :check_lock]
  
  # Define controller subsections
  def self.subsections
    [
      { :title => :summary,     :actions => [:index],       :roles => [:writer, :editor, :subeditor, :publisher, :admin] },
      { :title => :unsubmitted, :actions => [:unsubmitted], :roles => [:writer, :editor, :subeditor, :publisher, :admin] },
      { :title => :editing,     :actions => [:editing],     :roles => [:editor, :subeditor, :publisher, :admin] },
      { :title => :subediting,  :actions => [:subediting],  :roles => [:subeditor, :publisher, :admin] },
      { :title => :publishing,  :actions => [:publishing],  :roles => [:publisher, :admin] },
      { :title => :download,    :actions => [:download],    :roles => [:writer, :editor, :subeditor, :publisher, :admin] },
      { :title => :live,        :actions => [:live],        :roles => [:publisher, :admin] },
      { :title => :inactive,    :actions => [:inactive],    :roles => [:publisher, :admin] }
    ]
  end
  
  build_permissions
    
  # Article queues
  ############################################################################
  def index
    @articles ||= current_user.role.downcase.to_sym==:writer ? Article.recently_updated.where(:user_id=>current_user.id) : Article.recently_updated
    
    # Filters
    @articles = @articles.where(:publication_id => params[:publication_id]) if ( params[:publication_id]  && @publication = Publication.find(params[:publication_id]) )
    @articles = @articles.where(:section_id => params[:section_id]) if ( params[:section_id] && @section = Section.find(params[:section_id]) )
    @articles = @articles.where(["articles.title LIKE ? OR cached_authors LIKE ?", "%#{params[:q]}%", "%#{params[:q]}%"]) if params[:q]
    
    @articles = @articles.includes(:assets).includes(:lock).paginate(:page => params[:page])
    
    if request.xhr?
      render :partial => "list", :locals => {:articles => @articles}
      return
    end
    
    render :action => "index"
    
  end
  
  def unsubmitted
    @articles = current_user.role.downcase.to_sym==:writer ? Article.unsubmitted.where(:user_id=>current_user.id) : Article.unsubmitted
    index
  end
  
  def editing
    @articles = Article.editing
    index
  end
  
  def subediting
    @articles = Article.subediting
    index
  end
  
  def publishing
    @articles = Article.ready
    index
  end
  
  def live
    @articles = Article.live
    index
  end
  
  def inactive
    @articles = Article.inactive
    index
  end
  
  def download
    @articles = Article.downloadable
    index
  end
  
  
  # Main article pages
  ############################################################################
  
  # Show the article in either printable HTML or InDesign format
  def show
    
    # Load the requested article
    @article = Article.find( params[:id] )
    
    respond_to do |format|
      format.html do
        render :layout => "admin/show"    
      end
      
      format.indtt do
        # We are rendering for InDesign Tagged Text format. Need to massage the
        # content into an acceptable format
      
        # Render the template to a string then replace all HTML entities, remove
        # all CRLF line endings, and convert to UTF16 BigEndian (the only 
        # format that InDesign will read without complaining). Need to convert
        # line endings back to CR then, something to do with Mac formatting.
        out_string = HTMLEntities.new.decode( 
          render_to_string.gsub("\r\n", "\n").gsub("\n+", "\n") 
        )
        out_string = Iconv.iconv('utf-16be', 'utf-8', out_string.gsub("\n", "\r") )
      
        send_data out_string[0], 
          :disposition => "attachment; filename=#{@article.id}-#{@article.url}.indesign.txt", 
          :type=>"text/plain; charset=utf-16be"
      end
      
    end
    
  end
  
  
  
  def edit
    
    unless @article.locked? && !(@article.lock.user==current_user)
      if @article.locked?
        @article.lock.update_attribute(:updated_at, Time::now)
      else
        @article.lock!(current_user)
        @article.reload
      end
    end
    
    allowed = user_can_edit( @article )
    
    unless allowed
      flash[:error] = "You do not have permission to edit that article"
      redirect_to admin_articles_path and return
    end
    
    # Force the highlighted subsection tab to be the queue that the article
    # is currently in
    force_subsection @article.queue
    
  end



  def update

    if @article.update_attributes( params[:article] )
      @article.update_attribute( :section_id, params[:article][:section_id] )
      @article.unlock!( current_user )
      
      if params[:publish_now] && [:publisher, :admin].include?(current_user.role.downcase.to_sym)
         @article.publish_now! 
      elsif params[:stage_complete]
        @article.stage_complete!
      end
      @article.reload
      
      render :nothing => true and return if request.xhr?
      flash[:notice] = "Article has been saved"
      user_can_edit( @article ) ? redirect_to(:action => @article.queue) : redirect_to(:action => :index)
      
    else
      request.xhr? ? render(:nothing => true, :status => 403) : render(:action => :edit)
    end
    
  end
  
  
  def new
    force_subsection :unsubmitted
    @article = Article.new
    @article.writer_string = current_user.name
    render :layout => "admin/manual_sidebar"
  end
  
  
  
  def create
    
    @article = Article.new( params[:article] )
    
    # Set protected parameters
    @article.user = current_user
    @article.created_at = @article.updated_at = Time::now
    @article.section_id = params[:article][:section_id]

    if @article.save
      
      @article.stage_complete! if params[:stage_complete]
      @article.reload
      
      flash[:notice] = "Article has been saved"
      redirect_to :action => :index
    else
      force_subsection :unsubmitted
      render :action => :new
    end
    
  end
  
  
  def destroy
    @article.update_attribute(:status, Article::Status[:removed])
    flash[:notice] = "Article has been obliterated"
    redirect_to :action => :index
  end
  
  
  def unpublish
    @article.update_attribute(:status, Article::Status[:ready])
    flash[:notice] = "Article has been removed from the live site"
    redirect_to :action => :publishing
  end
  
  
  def check_lock
    unless @article.locked? && !(@article.lock.user==current_user)
      if @article.locked?
        @article.lock.update_attribute(:updated_at, Time::now)
      else
        @article.lock!(current_user)
        @article.reload
      end
    end
    @article.reload
    render :partial => "lock_info", :locals => {:article => @article}
  end
  
  
  
  
  private
  
  
  def load_defaults
    @all_sections = Section.order(:name)
    @all_publications = Publication.all.group_by(&:direction)
  end
  
  
  def get_article
    
    @article = Article.find(params[:id])
    
    unless user_can_edit( @article )
      flash[:error] = "You do not have permission to edit that article"
      render :nothing => true if request.xhr?
      redirect_to admin_articles_path and return false
    end
    
  end
  
  def user_can_edit(article)
    case (article.status)
    when Article::Status[:unsubmitted]
      allowed = [:editor, :subeditor, :publisher, :admin].include?(@current_user.role.downcase.to_sym) || (@article.user==@current_user)
    when Article::Status[:editing]
      allowed = [:editor, :subeditor, :publisher, :admin].include?(@current_user.role.downcase.to_sym)
    when Article::Status[:subediting]
      allowed = [:subeditor, :publisher, :admin].include?(@current_user.role.downcase.to_sym)
    when Article::Status[:ready]
      allowed = [:publisher, :admin].include?(@current_user.role.downcase.to_sym)
    when Article::Status[:published]
      allowed = [:publisher, :admin].include?(@current_user.role.downcase.to_sym)
    when Article::Status[:removed]
      allowed = false
    end
    
    return allowed
  end
  
end
