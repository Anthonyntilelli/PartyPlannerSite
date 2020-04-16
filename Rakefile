# frozen_string_literal: true

ENV['SINATRA_ENV'] ||= 'development'

require_relative './config/environment'
require 'sinatra/activerecord/rake'

# Pre-run check
raise 'Missing Send Grid key from ENV' unless ENV['SENDGRID_API_KEY']
raise 'Missing URL HMAC  key from ENV' unless ENV['HMAC_URl_KEY']
raise 'Missing Cookie session key from ENV' unless ENV['SESSION_KEY']
if Resolv::DNS.open { |dns| dns.getresources('gmail.com', Resolv::DNS::Resource::IN::MX) } == []
  raise 'DNS or internet is not working'
end

# Pre-run check
