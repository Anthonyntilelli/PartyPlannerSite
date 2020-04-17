# frozen_string_literal: true

ENV['SINATRA_ENV'] ||= 'development'

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
raise 'Missing Send Grid key from ENV' unless ENV['PARTY_SENDGRID_API_KEY']
raise 'Missing URL HMAC  key from ENV' unless ENV['PARTY_HMAC_URl_KEY']
raise 'Missing Cookie session key from ENV' unless ENV['PARTY_SESSION_KEY']
raise 'Missing Send Grid `TO` email address from ENV' unless ENV['PARTY_SENDGRID_EMAIL']

# Disable DNS CHECK
if ENV['PARTY_DISABLE_DNS'] != 'YES'
  if Resolv::DNS.open { |dns| dns.getresources('gmail.com', Resolv::DNS::Resource::IN::MX) } == []
    raise 'DNS or internet is not working'
  end
end
# Pre-run check

require './app/controllers/application_controller'
require_all 'app'
