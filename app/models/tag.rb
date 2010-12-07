class Tag < ActiveRecord::Base
  
  # Model definition
  ############################################################################
  
  has_many :taggings
  has_many :tagged_items, :through=>:taggings, :class_name=>( Proc.new{ taggings.taggable_type } )
  
  validates :name, :presence=>true
  
  # Class methods
  ############################################################################
  
  class << self
    
    def find_or_create(the_string)
      f = where( ["name LIKE ?", the_string] ).first
      return f if f
      f = new( :name => the_string )
      return f if f.save
    end
    
    def popular
      Tag.joins(:taggings).group(:tag_id).order("COUNT(tag_id) DESC")
    end
    
  end

end