source 'http://rubygems.org'

gem 'rails', '3.0.4'

# Essentials
gem "haml",         "3.0.25"
gem "jammit",       "0.5.4"
gem "fastercsv",    "1.5.3"
gem "htmlentities", "4.2.2"
gem "zip",          "2.0.2"
gem "chronic",      "0.3.0"
#gem "newrelic",     "2.13.4"


# Need to require the correct name
gem "mime-types",   "1.16", :require => "mime/types"

# Gems from Git
gem "lapluviosilla-tickle", 
  :git => "https://github.com/lapluviosilla/tickle.git", 
  :require => "tickle"
  
gem "paper_trail",
    :git => "http://github.com/mattmacleod/paper_trail.git"
    
gem "will_paginate",
		:git => "http://github.com/mislav/will_paginate.git",
		:branch => "rails3"
		
gem 'paperclip',
    :git => "http://github.com/mattmacleod/paperclip.git"
        
        
# Development only
group :development do
  gem "mongrel"
  gem "cgi_multipart_eof_fix"
  gem "fastthread"
  gem "mongrel_experimental"
  gem "dr_dre"
  gem "ruby-debug"
  gem "jeweler",      "1.5.2"
end
  
# Testing only
group :test do
  gem "autotest"
  gem "autotest-rails"
  gem "shoulda"
  gem "factory_girl_rails"
  gem "rcov"
  gem "rmagick"
end

# Development database
group :development, :test do
  gem 'sqlite3-ruby', :require => 'sqlite3'
end