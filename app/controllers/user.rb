# frozen_string_literal: true

# User controller with Sinatra
class UserController < Sinatra::Base
  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    use Rack::MethodOverride # Method overwrite
    enable :sessions
    set :session_secret, 'secret'
    register Sinatra::Flash
  end

  # User can log-in (password less log in also??)
  # User can verify email owernship
  # User can update recover their account, if locked or forgotten password
  # User can logout
  # User can delete their account

  # User can signup
  get '/user/signup' do
    @title = 'Welcome to the party'
    @header_text = 'Party Planning, inc'
    @follow_up_paragraph = 'Best Place to Schedule your Party!'
    erb :"user/signup"
  end

  post '/user/signup' do
    begin
      # TODO: Sanitize Input
      User.create!(
        name: params['name'],
        email: params['email'],
        email_confirmation: params['email_confirmation'],
        password: params['password'],
        password_confirmation: params['password_confirmation'],
        valid_email: false,
        locked: true,
        admin: false
      )
    rescue ActiveRecord::RecordInvalid => e
      flash[:SUCCESS] = e.message
      redirect "/user/signup"
    end
    # TODO: Send email validation for user accound
    flash[:SUCCESS] = "Signup Successfull: Welcome #{params["name"]}, please view your email for confirm link."
    redirect '/'
  end

  # User can view Profile
  get '/user/profile/:id' do
  end

  # User can update Profile
  patch '/user/profile/:id' do
  end
end
