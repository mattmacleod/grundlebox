require 'rails/generators'

class MigrationsGenerator < Rails::Generators::Base
  include Rails::Generators::Migration

  def self.source_root
    @source_root ||= File.join( Grundlebox::Engine.root, "db", "migrate" )
  end

  def self.next_migration_number(dirname)
    "%.3d" % (current_migration_number(dirname) + 1)
  end

  # Bit hacky.
  def create_migration_file
    Dir[ File.join( Grundlebox::Engine.root, "db", "migrate" ) ].each do |file| 
      template file.split("/").last, "db/migrate/#{file.split("/").last}"
    end
  end
  
end
