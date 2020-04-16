# frozen_string_literal: true

require './config/environment'
if ActiveRecord::Base.connection.migration_context.needs_migration?
  raise 'Migrations are pending. Run `rake db:migrate` to resolve the issue.'
end

# Pre-run check
raise 'Missing Send Grid key from ENV' unless ENV['SENDGRID_API_KEY']
raise 'Missing URL HMAC  key from ENV' unless ENV['HMAC_URl_KEY']
raise 'Missing Cookie session key from ENV' unless ENV['SESSION_KEY']
if Resolv::DNS.open { |dns| dns.getresources('gmail.com', Resolv::DNS::Resource::IN::MX) } == []
  raise 'DNS or internet is not working'
end

# Pre-run check

use AuthController # keep as first
use UserController
use ThemeController
use VenueController
use PartyController
use Rack::MethodOverride # Method overwrite
run ApplicationController
