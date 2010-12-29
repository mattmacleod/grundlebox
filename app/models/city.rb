class City < ActiveRecord::Base
  
  # Model definition
  ############################################################################
  has_many :venues, :dependent => :destroy
  has_many :performances, :through => :venues
  
  validates :name, :presence => true, :uniqueness => true
  
  class << self
    
    def options_for_select
      all.map{|c| [c.name, c.id]}
    end
    
  end
  
end