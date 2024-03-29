


# This file is automatically copied into RAILS_ROOT/initializers

#require "smtp_tls"

config_file = "#{RAILS_ROOT}/config/smtp_gmail.yml"
raise "Sorry, you must have #{config_file}" unless File.exists?(config_file)

config_options = YAML.load_file(config_file) 
ActionMailer::Base.smtp_settings = {
  :enable_starttls_auto => true,
      :address => "smtp.gmail.com",
      :port => 25,
      :domain => "gmail.com",
      :authentication => :plain,
      :user_name => "eventsparks@gmail.com",
      :password => "shamithc"
}.merge(config_options) # Configuration options override default options
