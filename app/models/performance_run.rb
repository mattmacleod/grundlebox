class PerformanceRun < ActiveRecord::Base
  
  # Table-less model
  class_inheritable_accessor :columns
  self.columns = []

  def self.column(name, sql_type = nil, default = nil, null = true)
    columns << ActiveRecord::ConnectionAdapters::Column.new(name.to_s, default, sql_type.to_s, null)
  end
    
  column :run_type, :string
  
  column :start_date, :date
  column :end_date, :date
  
  column :one_off_start_time, :datetime
  column :one_off_end_time, :datetime
  
  column :periodic_start_time, :time
  column :periodic_end_time, :time
  
  column :nl_string, :string
  
  column :venue_id, :integer
  
    
  # Model definition
  ############################################################################
  
  # Validation
  validates_presence_of :run_type
  validates_inclusion_of :run_type, :in => ["one_off", "periodic", "opening_times"]
  validates_presence_of :one_off_start_time, :if => Proc.new{ run_type=="one_off" }
  validates_presence_of :periodic_start_time, :nl_string, :start_date, :end_date, :if => Proc.new{ run_type=="periodic" }
  validates_presence_of :venue, :if => Proc.new{ run_type=="opening_times" }
  
  validates_presence_of :performance
  
  # Relationships
  belongs_to :venue
  belongs_to :performance
  
  accepts_nested_attributes_for :performance
  
  
  # Methods
  ############################################################################
  
  # Returns a list of performances based on the prototype and the date details
  def get_performances
    
    return false unless valid?
    
    # List of performances to return
    performances = []
    
    case run_type
    when "one_off"
      
      # Create one performance
      p = Performance.new( performance.attributes )
      p.user = User.new
      p.event = Event.new
      p.starts_at = one_off_start_time
      p.ends_at = one_off_end_time
      performances << p
      
    when "periodic"
      
      # Create multiple performances from the supplied dates
      
      # Get the dates
      dates = []
      current_date = start_date
      while( current_date && (current_date <= end_date) ) do
        parsed = Tickle.parse( "#{nl_string}", :now => current_date, :start => current_date )
        return false unless parsed
        break if parsed[:next] > end_date
        dates << parsed[:next]
        current_date = (parsed[:next] + 1.day > current_date) ? (parsed[:next] + 1.day) : nil
      end
      
      # Convert dates to time pairs
      times = []
      dates.each do |date|
        
        # Get the start time
        start_time = Time::parse(date.strftime("%Y-%m-%d") + " " + periodic_start_time.strftime("%H:%M") + " UTC" ).utc
        
        # Is there an end time?
        if periodic_end_time
          
          # Create the end time. If it's before the start time, add a day - we've
          # wrapped around into the wee small hours
          end_time = Time::parse(date.strftime("%Y-%m-%d") + " " + periodic_end_time.strftime("%H:%M") + " UTC" ).utc
          end_time += 1.day if end_time < start_time
          
          times << { 
            :start_time => start_time,
            :end_time => end_time
          }
          
        else
          
          times << { :start_time => start_time }
          
        end
        
      end
      
      # Now create the performances
      times.each do |time|
        p = Performance.new( performance.attributes )
        p.user = User.new
        p.event = Event.new        
        p.starts_at = time[:start_time]
        p.ends_at = time[:end_time]
        performances << p
      end
      
      
    when "opening_times"
      
      # Not implemented yet
      return false;
      
    end
    
    return performances if performances.all?(&:valid?)
    
    return false
    
  end
       
end