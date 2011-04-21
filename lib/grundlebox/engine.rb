module Grundlebox
  class Engine < Rails::Engine
  
    initializer "static assets" do |app|
      app.middleware.insert_after ActionDispatch::Static, ActionDispatch::Static, "#{root}/public"
    end
    
  end
end
