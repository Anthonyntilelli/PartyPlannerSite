# frozen_string_literal: true

require './config/environment'
if ActiveRecord::Base.connection.migration_context.needs_migration?
  raise 'Migrations are pending. Run `rake db:migrate` to resolve the issue.'
end

use AuthController # keep as first
use UserController
use ThemeController
use VenueController
use PartyController
use Rack::MethodOverride # Method overwrite (keep above run)
run ApplicationController
