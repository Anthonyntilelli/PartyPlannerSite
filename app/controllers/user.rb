# frozen_string_literal: true

# User controller with Sinatra
class UserController < Sinatra::Base
  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    use Rack::MethodOverride # Method overwrite
    enable :sessions
    set :session_secret, "secret"
  end

  # User can log-in (password less log in also??)
  # User can verify email owernship
  # User can update recover their account, if locked or forgotten password
  # User can logout
  # User can delete their account

  # User can signup
  get '/user/signup' do
    erb :"user/signup"
  end

  post '/user/signup' do
    # CGI::escapeHTML(params["email"])
    # Rack::Utils.escape_html("quote ' double quotes \"")
    # params['name']
    # binding.pry
    erb :welcome
  end

  # User can view Profile
  get '/user/profile/:id' do
  end

  # User can update Profile
  patch '/user/profile/:id' do
  end
end
