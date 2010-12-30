source 'http://rubygems.org'

gem 'rails', '3.0.3'

# Essentials
gem "mysql", :require => "mysql"
gem "haml"
gem "jammit"
gem "fastercsv"
gem "htmlentities"
gem "zip"
gem "mime-types", :require => "mime/types"


gem "paper_trail",
    :git => "http://github.com/mattmacleod/paper_trail.git"
gem "will_paginate", 
		:git => "http://github.com/mislav/will_paginate.git",
		:branch => "rails3"
gem 'paperclip', 
    :git => "http://github.com/mattmacleod/paperclip.git"
        
        
# Development
group :development do
  gem "mongrel"
  gem "cgi_multipart_eof_fix"
  gem "fastthread"
  gem "mongrel_experimental"
  gem "dr_dre"
  gem "ruby-debug"
end
  
# Testing
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
