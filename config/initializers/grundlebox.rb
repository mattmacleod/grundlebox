# Load default configuration
require File.expand_path(File.dirname(__FILE__) + "/../grundlebox.rb" )

# Load the application
require "grundlebox"

# Stub remote tests
if Rails.env=="test"
  require "test_stub"
end

# Set default date formats
Date::DATE_FORMATS[:default] = '%d %b %Y'
Time::DATE_FORMATS[:date] = '%d %b %Y'
Time::DATE_FORMATS[:date_only] = '%d %b %Y'
Time::DATE_FORMATS[:datetime] = '%d %b %Y %H:%M'
Time::DATE_FORMATS[:listings] = '%a %d %b %Y %H:%M'

Time::DATE_FORMATS[:parseable] = '%Y-%m-%d %H:%M'
Date::DATE_FORMATS[:parseable] = '%Y-%m-%d'
