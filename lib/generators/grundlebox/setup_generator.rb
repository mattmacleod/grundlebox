require 'rails/generators'
require 'rails/generators/migration'
require 'rails/generators/active_record/migration'

module Grundlebox
  class SetupGenerator < Rails::Generators::Base
    
    include Rails::Generators::Migration
    extend ActiveRecord::Generators::Migration

    source_root File.join( Grundlebox::Engine.root, "db", "migrate" )

    desc 'Generates (but does not run) migrations to add Grundlebox tables, and copies config files.'

    def self.next_migration_number(dirname) #:nodoc:
      "%.3d" % (current_migration_number(dirname) + 1)
    end

    def create_migration_file
      Dir[ File.join( Grundlebox::Engine.root, "db", "migrate", "*" ) ].each do |file| 
        template file.split("/").last, "db/migrate/#{file.split("/").last}"
      end
    end

    def copy_config_files
      copy_file File.join( Grundlebox::Engine.root, "config", "grundlebox.rb" ), 'config/grundlebox.rb'
      copy_file File.join( Grundlebox::Engine.root, "config", "grundlebox_menu.yml" ), 'config/grundlebox_menu.yml'
    end

    def update_application_controller
      gsub_file("app/controllers/application_controller.rb", "ActionController::Base", "GrundleboxApplicationController")
    end
  
  end
end