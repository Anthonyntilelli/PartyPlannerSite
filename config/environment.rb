# frozen_string_literal: true

ENV['SINATRA_ENV'] ||= 'development'
$HOST = 'http://127.0.0.1:9393'

require 'bundler/setup'
require 'sinatra/flash'
require 'uri'
require 'resolv'
require 'securerandom'
require 'sendgrid-ruby'
Bundler.require(:default, ENV['SINATRA_ENV'])

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: "db/#{ENV['SINATRA_ENV']}.sqlite"
)

# Pre-run check
raise 'Missing Send Grid key from ENV' unless ENV['SENDGRID_API_KEY']
raise 'Missing URL HMAC  key from ENV' unless ENV['HMAC_URl_KEY']
raise 'Missing Cookie session key from ENV' unless ENV['SESSION_KEY']

# Disable DNS CHECK
if ENV['NO_DNS'] != 'true'
  if Resolv::DNS.open { |dns| dns.getresources('gmail.com', Resolv::DNS::Resource::IN::MX) } == []
    raise 'DNS or internet is not working'
  end
end
# Pre-run check

require './app/controllers/application_controller'
require_all 'app'
