#source 'http://rubygems.org'

gem 'rails'
#gem 'rails', '3.1.0'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'


# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger (ruby-debug for Ruby 1.8.7+, ruby-debug19 for Ruby 1.9.2+)
# gem 'ruby-debug'
# gem 'ruby-debug19'

# Bundle the extra gems:
# gem 'bj'
# gem 'nokogiri'
# gem 'sqlite3-ruby', :require => 'sqlite3'
# gem 'aws-s3', :require => 'aws/s3'

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
# group :development, :test do
#   gem 'webrat'
# end

gem 'nokogiri', '< 1.6'

gem 'paperclip'
gem 'jquery-rails'
gem 'aws-sdk'

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'meta_request'
end

group :development, :test do
	gem 'sqlite3-ruby', :require => 'sqlite3'
end

group :production do
  gem 'mysql2'
end

gem 'jquery-turbolinks'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
gem 'bootstrap-sass'
gem 'devise'

group :assets do
  gem 'uglifier'
end 

gem 'jquery-ui-rails', '4.2.1'

# For Abhiroop's Dabba
#gem 'sass-rails', git: 'http://github.com/rails/sass-rails'
#gem 'activeadmin', git: 'http://github.com/gregbell/active_admin'

#For AWS
gem 'sass-rails', github: 'rails/sass-rails'
gem 'activeadmin', github: 'gregbell/active_admin'

# Cron jobs in Ruby
gem 'whenever', :require => false
# For displaying emails in browser in dev mode
gem "letter_opener", :group => :development
# For browser checks
gem "browser"
# For pagination
gem 'kaminari'

gem 'delayed_job_active_record'
gem "daemons"