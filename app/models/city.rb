class City < ActiveRecord::Base
  
  # Model definition
  ############################################################################
  has_many :venues, :dependent => :destroy
  has_many :performances, :through => :venues
  
  validates :name, :presence => true, :uniqueness => true
  
end