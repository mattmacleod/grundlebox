
class AssetFolder < ActiveRecord::Base
  
  # Model definition
  ############################################################################
  
  # Relationships
  belongs_to :parent, :class_name=>"AssetFolder", :foreign_key=>:parent_id
  has_many :children, :class_name=>"AssetFolder", :foreign_key=>:parent_id,
           :dependent => :destroy, :order => "name ASC"
  has_many :assets
  
  # Validations
  validates :name, :presence => true
  validates_uniqueness_of :name, :scope => :parent_id
  validates_associated :parent
  validates :parent_id, :tree => true
  
  after_save :clear_node_cache
  after_destroy :clear_node_cache
  
  # Class methods
  ############################################################################
  
  def self.root
    return @nodes.select{|n| n && !n.parent_id }.first
  end
  
  # Instance methods
  ############################################################################
  
  def ancestors
    return @ancestors ||= parent ? (parent.ancestors + [self]) : [self]
  end
  
  def to_param
    "#{id}-#{Grundlebox::Util.pretty_url(name)}"
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
    return @nodes
  end
  
  def self.with_id(id)
    return nodes[id.to_i] if nodes[id.to_i]
    raise ActiveRecord::RecordNotFound
  end
  
  def parent
    AssetFolder::nodes[self.parent_id] rescue nil
  end
  
  def children
    return AssetFolder::nodes.select{|n| n && n.parent_id == self.id }.sort_by(&:name)
  end
  
  private
  
  def clear_node_cache
    self.class.nodes = nil
  end
  
end