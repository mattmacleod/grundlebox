class Venue < ActiveRecord::Base
  
  # Distance values are in miles
  EARTH_RADIUS_IN_MILES = 3963.19
  MILES_PER_LATITUDE_DEGREE = 69.1
  PI_DIV_RAD = 0.0174
  LATITUDE_DEGREES = EARTH_RADIUS_IN_MILES / MILES_PER_LATITUDE_DEGREE  
  
  # Model definition
  ############################################################################
  
  # Relationships
  belongs_to :user
  belongs_to :city
  has_many :performances, :dependent => :destroy
  has_many :events, :through => :performances
  has_and_belongs_to_many :articles
  
  # Validations
  validates :title, :presence => true
  validates :user, :presence => true
  validates :user, :presence => true
  validates :email, :format => { :with => Grundlebox::Config::EmailRegexp }, :if => :email
  validates :url, :presence => true, :url => true
  
  # Library stuff
  grundlebox_has_tags
  grundlebox_has_comments
  #grundlebox_has_assets
  #grundlebox_has_lock
  grundlebox_has_url   :url, :generated_from => :title
  
  
  # Class methods
  ############################################################################
  
  class << self
    
    def in_region(lat, lng, radius = 5)
      select("venues.*, #{distance_query_string(lat, lng)}").
      where("NOT lat IS NULL").
      having("distance<#{radius}").
      group("venues.id").order("distance ASC")
    end
    
  end


  # Instance methods
  ############################################################################
  
  def has_location?
    return !lat.nil? && !lng.nil?
  end
  
  def nearby
    return nil unless has_location?
    self.class.select("venues.*, #{self.class.distance_query_string(lat, lng)}").
      where("NOT venues.id=#{id}").where("NOT lat IS NULL").where("city_id=#{city_id}").
      group("venues.id").order("distance ASC")
  end
  
  def distance_from(other_venue)
    return nil unless has_location?
    v = self.class.select("#{self.class.distance_query_string(lat, lng)}").
      where("venues.id=#{other_venue.id}").where("NOT lat IS NULL").first.distance
  end
  
  
  private
  
  # Get the distance query string
  def self.distance_query_string(lat, lng)
    lat_degree_units,lng_degree_units = decode_flat_distance(lat)
    lat_dist = "#{lat_degree_units}*(#{lat} - lat)"
    lng_dist = "#{lng_degree_units}*(#{lng} - lng)" 

    min_factor = 0.415
    max_factor = 0.945
    lat_dist = "abs(#{lat_dist})"
    lng_dist = "abs(#{lng_dist})"
    sql = "(min(#{lat_dist},#{lng_dist})*0.415 + max(#{lat_dist},#{lng_dist})*0.945) AS distance"
  end
  
  def self.decode_flat_distance(lat)
    lat_degree_units = MILES_PER_LATITUDE_DEGREE
    lng_degree_units = (LATITUDE_DEGREES * Math.cos(lat * PI_DIV_RAD)).abs
    [lat_degree_units, lng_degree_units]
  end
        
end