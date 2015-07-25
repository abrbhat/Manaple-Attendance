# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!

require "smtp_tls"

ActionMailer::Base.smtp_settings = {
:address => ENV["SMTP_ADDRESS"],,
:port => 587,
:authentication => :plain,
:user_name => ENV["MAIL_USERNAME"],
:password => ENV["MAIL_PASSWORD"]
} 
