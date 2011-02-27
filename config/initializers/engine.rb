# Load engine-only code
if !defined?( Grundlebox::Application )
  
  # We're an engine. Check if the host application is also using Jammit. If it
  # is, then we need to merge the configuration files together.
  if File.exist?( pconf = File.join( Rails.root, "config", "assets.yml") )    
    
    merged = File::open( File.join( Rails.root, "tmp", "assets.yml"), "w" )
    app_config = YAML::load( ERB.new( IO.read(pconf) ).result )
    engine_config = YAML::load( ERB.new( IO.read(File.expand_path( File.dirname(__FILE__) + "/../assets.yml")) ).result )
    engine_config["javascripts"].merge!( app_config["javascripts"] )
    engine_config["stylesheets"].merge!( app_config["stylesheets"] )
    
    merged << engine_config.to_yaml 
    merged.close
    
    Jammit.load_configuration( merged.path, false)    
    
  else
    # There is no Jammit config in the host application, so just load ours
    Jammit.load_configuration( File.expand_path( File.dirname(__FILE__) + "/../assets.yml"), false)    
  end
end