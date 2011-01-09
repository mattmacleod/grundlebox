class Page < ActiveRecord::Base
  
  # Model definition
  ############################################################################
  
  # Relationships
  belongs_to :user
  belongs_to :menu
  belongs_to :parent, :class_name => "Page", :foreign_key => "parent_id"
  has_many :children, :class_name => "Page", :foreign_key => "parent_id", :dependent => :destroy
  has_many :page_widgets, :order => "sort_order ASC"
  has_many :widgets, :through => :page_widgets, :order => "sort_order ASC"
  
  # Validations
  validates_presence_of :page_type, :user, :title, :menu, :sort_order
  validates_presence_of :url, :unless => Proc.new{ !parent }
  validates :parent_id, :tree => true
  validates_uniqueness_of :url, :scope => :menu_id
  
  # Libraries
  grundlebox_has_comments
  grundlebox_has_versions :title, :abstract, :content
  grundlebox_has_tags
  
  # Attributes
  attr_accessible :url, :page_type, :title, :abstract, :content, :starts_at, :ends_at, :parent_id, :enabled
  
  # Tree cache
  after_save :clear_node_cache
  after_destroy :clear_node_cache
  
  # Class methods
  ############################################################################
  
  def self.root
    where(:parent_id=>nil).first
  end
  
  # Instance methods
  ############################################################################
  
  def ancestors
    return @ancestors ||= (parent ? (parent.ancestors + [self]) : [self])
  end
  
  def to_param
    "#{id}-#{Grundlebox::Util.pretty_url(title)}"
  end
  
  def path
    ancestors.map{|a| a.to_param }
  end

  # Node caching to reduce queries
  ############################################################################
  
  cattr_accessor :nodes
  def self.nodes
    return @nodes if (@nodes && !(Rails.env=="test")) # Disable caching in test mode    
    @nodes = []
    order(:id).each{|n| @nodes[n.id] = n }
    @nodes = @nodes
    return @nodes
  end
  
  def self.with_id(id)
    return nodes[id] if nodes[id]
    raise ActiveRecord::RecordNotFound
  end
  
  def parent
    self.class.nodes[self.parent_id] rescue nil
  end
  
  def children
    return self.class.nodes.select{|n| n && n.parent_id == self.id }.sort_by(&:sort_order)
  end
  
  private
  
  def clear_node_cache
    self.class.nodes = nil
  end


end