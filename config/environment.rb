# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!

require "smtp_tls"

ActionMailer::Base.smtp_settings = {
:address => "smtp.manaple.com",
:port => 587,
:authentication => :plain,
:user_name => "no-reply@manaple.com",
:password => "rlMZCfw9"
} 