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
  validates_associated :parent
  validates :parent_id, :tree => true
  validates_uniqueness_of :url, :scope => :menu_id
  
  # Libraries
  grundlebox_has_comments
  grundlebox_has_versions
  grundlebox_has_tags
  
  def self.root
    where(:parent_id=>nil).first
  end
  
  def ancestors
    return parent ? parent.ancestors+[self] : [self]
  end

end