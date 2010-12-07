class ApiRequest < ActiveRecord::Base
  
  # Model definition
  ############################################################################
  
  # Relationships
  belongs_to :api_key
  
  # Validations
  validates_presence_of :api_key, :version, :url, :status, :ip
  
end
