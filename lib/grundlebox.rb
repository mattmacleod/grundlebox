# Include required Grundlebox libraries

require "core_extensions"
require "export"
require "validators"
require "util"

# Load model extensions
Dir[ File.expand_path(File.dirname(__FILE__) + '/model_extensions/*.rb') ].each do |file| 
  require file 
end

# Load controller extensions
Dir[ File.expand_path(File.dirname(__FILE__) + '/controller_extensions/*.rb') ].each do |file| 
  require file 
end

require "cropper"


class Grundlebox::Internal
  
  Version = "1.0"
  
end