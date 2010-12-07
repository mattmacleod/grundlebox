
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
  
  def self.root
    where(:parent_id=>nil).first
  end
  
  def ancestors
    return parent ? parent.ancestors+[self] : [self]
  end
  
  def to_param
    "#{id}-#{Grundlebox::Util.pretty_url(name)}"
  end
  
  def path
    ancestors.map{|a| a.to_param }
  end
  
end