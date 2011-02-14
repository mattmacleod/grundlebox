module Grundlebox

  Version = File.read( File.expand_path( File.dirname(__FILE__) + "/../VERSION" ) )

  # Load the engine if required
  unless defined?( Grundlebox::Application )
    require "grundlebox/engine" 
    require "generators/grundlebox/migrations/migrations_generator"
  end
  
  # Load external libraries. I don't quite understand why I have to do this.
  # Something screwy is going on with the load order.
  require "paper_trail"
  require "will_paginate"
  require "paperclip"
  require "jammit"
  
  # Load Grundlebox library files
  require "core_extensions"
  require "paperclip/cropper"
  require "grundlebox/export"
  require "grundlebox/validators"
  require "grundlebox/util"
  require "grundlebox/labelled_form_builder"
  
  # Load model extensions
  Dir[ File.expand_path(File.dirname(__FILE__) + '/grundlebox/model_extensions/*.rb') ].each do |file| 
    require file 
  end

  # Setup JSON configuration
  ActiveRecord::Base.include_root_in_json = false
    
end