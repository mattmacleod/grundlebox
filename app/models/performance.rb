class Performance < ActiveRecord::Base
    
  # Model definition
  ############################################################################
  
  # Relationships
  belongs_to :user
  belongs_to :venue
  belongs_to :event
  has_one :city, :through => :venue
  
  # Validations
  validates_presence_of :event, :venue, :user, :starts_at
  validates_each :ends_at do |record, attr, value|
    record.errors.add attr, 'cannot be before start time' if (value && (value < record.starts_at))
  end
  
  # Cache
  before_save :update_caches
  after_save :update_event_caches
  after_destroy :update_event_caches
  
  # Class methods
  ############################################################################
  
  class << self
    
    def upcoming
      where("starts_at>=? OR (NOT ends_at IS NULL AND ends_at>=?)", Time::now, Time::now)
    end
    
  end


  # Instance methods
  ############################################################################
  
  def upcoming?
    return ((starts_at >= Time::now) || (ends_at && (ends_at >= Time::now)))
  end

  def affiliate_type
    return read_attribute(:affiliate_type) || event.affiliate_type
  end
  
  def affiliate_code
    return read_attribute(:affiliate_code) || event.affiliate_code
  end
  
  
  # Cached value updates
  ############################################################################

  def update_caches
    self.cached_venue_name  = venue.title
    self.cached_venue_link  = venue.url
    self.cached_city_name   = venue.city ? venue.city.name : nil
    self.cached_event_name  = event.title
    self.cached_event_link  = event.url
    self.cached_description = event.abstract
  end
  
  # Avoid callbacks!
  def update_event_caches
    Event.update_all( {
      :cached_times => event.time_string, :cached_dates => event.date_string, 
      :cached_prices=> event.price_string, :cached_venues=> event.venue_string
    }, {:id=>event.id} )
  end
  
end
