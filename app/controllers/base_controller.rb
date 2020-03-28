# frozen_string_literal: true

# Base controller that will have helper, setting and other related info for all other controllers
class BaseController < Sinatra::Base
  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    set :session_secret, 'secret'
    enable :sessions
    register Sinatra::Flash
    use Rack::MethodOverride # Method overwrite
  end

  # Sanitize Input
  before do
    clean = SanitizeUtils.sanitize_hash(params)
    @params = clean
  end
end
