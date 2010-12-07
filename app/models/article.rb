class Article < ActiveRecord::Base
  
  # Model definition
  ############################################################################

  # Constants 
  Status = {
    :unsubmitted => "NEW", 
    :editing     => "EDITING",
    :subediting  => "SUBEDITING", 
    :ready       => "READY", 
    :published   => "PUBLISHED", 
    :removed     => "REMOVED" 
  }
  
  SortOrder = {
    :rating => "review_rating DESC",
    :name   => "articles.title ASC",
    :newest => "starts_at DESC, articles.created_at DESC"
  }
  
  
  # Relationships
  belongs_to :section
  belongs_to :publication
  belongs_to :user
  has_and_belongs_to_many :events
  has_and_belongs_to_many :venues
  has_many :reviewed_events, :class_name => "Event", :foreign_key => "review_id", :dependent => :nullify
  has_many :performances, :through => :events
  
  
  # Authors
  has_many :authors, :order => :sort_order, :dependent => :destroy
  has_many :authoring_users, :through => :authors, :source => :user,
           :class_name => "User", :foreign_key => "user_id"
  after_save :build_authors
  attr_accessor :writer_string


  # Library stuff
  #grundlebox_has_tags
  #grundlebox_has_comments
  #grundlebox_has_assets
  grundlebox_has_url   :url, :generated_from => :title
  #grundlebox_has_lock
  
  
  # Validations
  validates_presence_of :title, :template, :word_count, :article_type, :user
  validates_presence_of :section, :message => "must be specified"
  validates_presence_of :review_rating, :if => Proc.new{ review }
  
  validates :status, :presence => true, :inclusion => { :in => Article::Status::values }
  
  
  # Accessiblity
  attr_accessible :title, :abstract, :standfirst, :pullquote, :content, 
                  :footnote, :web_address, :featured, :print_only, :template,
                  :article_type, :section, :private_notes, :publication, 
                  :review, :review_rating, :starts_at, :ends_at, :writer_string, 
                  :publication_id, :associated_event_ids, :tag_list, :asset_ids
    
  # Callbacks
  before_save :save_word_count
  

  # Class methods
  ############################################################################

  class << self
  
    # Returns relation for +number+ recently-updated, active articles
    def recently_updated( number = 1 )
      active.order("articles.updated_at DESC").limit(number)
    end
    
    def unsubmitted
      where(:status=>Status[:unsubmitted]).order("articles.updated_at DESC")
    end

    def editing
      where(:status=>Status[:editing]).order("articles.updated_at DESC")
    end
    
    def subediting
      where(:status=>Status[:subediting]).order("articles.updated_at DESC")
    end
    
    def ready
      a = where(
        "status='#{Status[:ready]}' OR "+
        "(status='#{Status[:published]}' AND starts_at >= ?)", Time::now
      )
      a.order("articles.updated_at DESC")
    end
    
    def inactive
      a = where(
        "status='#{Status[:published]}' AND "+
        "( print_only=1 OR ( (NOT(ends_at IS NULL )) AND ends_at <=? ) )", Time::now
      )
      a.order("articles.updated_at DESC")
    end
    
    def downloadable
      a = where( 
        "status='#{Status[:ready]}' OR (status='#{Status[:published]}')"
      )
      a.order("articles.updated_at DESC")
    end
    
    def active
      where("NOT status=?", Article::Status[:removed])
    end
    
    def live
      where(
        "status=? AND starts_at<=? AND "+
        "(ends_at IS NULL OR ends_at >= ?) AND print_only=?", 
        Status[:published], Time::now, Time::now, false
      )
    end
    
  end


  # Instance methods
  ############################################################################
  
  def queue
    case status
    when Status[:unsubmitted]
      return :unsubmitted
    when Status[:editing]
      return :editing
    when Status[:subediting]
      return :subediting
    when Status[:ready]
      return :publishing
    when Status[:published]
      return :publishing if (starts_at && starts_at >= Time::now)
      return :inactive if (print_only || (ends_at && ends_at<=Time::now))
      return :live
    end
    return nil
  end
  
  
  def live?
    return status == Status[:published] && starts_at && starts_at<=Time::now && 
           (!ends_at || ends_at>Time::now) && !print_only
  end
  
  
  # Handle properties
  serialize :properties
  def properties=( props )
    self[:properties] ? self[:properties].merge!(props) : self[:properties] = props
  end
  
  def properties
    self[:properties] || {}
  end
  
  
  def stage_complete!
    
    case status
      when Status[:unsubmitted]
        new_status = Status[:editing]
      when Status[:editing]
        new_status = Status[:subediting]
      when Status[:subediting]
        new_status = Status[:ready]
      when Status[:ready]
        new_status = Status[:published]
      else
        new_status = status
    end
    update_attribute(:starts_at, Time::now) if new_status==Status[:published] && !starts_at
    update_attribute(:status, new_status)
  end
  
  def publish_now!
    update_attribute(:starts_at, Time::now) if !starts_at
    update_attribute(:status, Status[:published])
  end
  
  def get_abstract
    abstract.blank? ? ( standfirst.blank? ? content : standfirst ) : abstract
  end
  
  
  # Private methods
  ############################################################################

  private
    
  def build_authors
    return if @writer_string.nil?
    
    authors.destroy_all
    
    @writer_string.split(",").map(&:strip).uniq.each_with_index do |author, index|
      if (user = User.where(["name LIKE ? AND NOT role=?", author, "USER"]).first)        
        authors << Author.create!(:article => self, :user => user, :sort_order => index)
      else
        authors << Author.create!(:article => self, :name => author, :sort_order => index)
      end
    end
        
    self[:cached_authors] = authors.blank? ? nil : authors.map{|a| a.display_name }.join(", ")

    @writer_string = nil
    save!
  end
  
  # Word count
  def save_word_count
    self[:word_count] = content.to_s.strip_html.split(/\s/).length
  end
  
end
