# Include required Grundlebox libraries
require "core_extensions"
require "export"
require "validators"
require "util"
require "labelled_form_builder"
require "cropper"

# Load model extensions
Dir[ File.expand_path(File.dirname(__FILE__) + '/model_extensions/*.rb') ].each do |file| 
  require file 
end

# Load controller extensions
Dir[ File.expand_path(File.dirname(__FILE__) + '/controller_extensions/*.rb') ].each do |file| 
  require file 
end

# Setup JSON
ActiveRecord::Base.include_root_in_json = false

class Grundlebox::Internal  
  Version = "1.0"
end