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

  # TODO: Sanitize Input
  # passwordless log in also??
  # User can reset their account
  # User can verify email owernship
  # User can update recover their account, if locked or forgotten password
  # User can delete their account

  # User signup Page
  get '/user/signup' do
    @title = 'Welcome to the party'
    @header_text = 'Party Planning, inc'
    @follow_up_paragraph = 'Best Place to Schedule your Party!'
    erb :"user/signup"
  end

  # Create User account
  post '/user/signup' do
    begin
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
      flash[:ERROR] = e.message
      redirect '/user/signup'
    end
    # TODO: Send email validation for user accound
    flash[:SUCCESS] = "Signup Successfull: Welcome #{params['name']}, please view your email for confirm link."
    redirect '/'
  end

  # User Log-in
  get '/user/login' do
    redirect to '/' if session['user_id']
    @title = 'Welcome to the party'
    @header_text = 'Party Planning, inc'
    @follow_up_paragraph = 'Best Place to Schedule your Party!'
    erb :"user/login"
  end

  # Authenticate User
  post '/user/login' do
    user = User.find_by(email: params['email'])
    if user&.authenticate(params['password'])
      if !user.locked && user.valid_email
        session['user_id'] = user.id
        session['login_time'] = Time.now.utc.to_s
        redirect to '/', 200
      else
        session['user_id'] = nil
        session['login_time'] = nil
        flash[:ERROR] = 'Email is locked or email is not verified, please click \'Forgot my password\' to unlock'
        redirect to '/user/login', 401
      end
    else
      flash[:ERROR] = 'Incorrect User or Password'
      redirect to '/user/login', 401
    end
    halt 404
  end

  # Logout and clears session
  get '/user/logout' do
    session.clear
    flash[:SUCCESS] = 'You are Logged out'
    redirect to '/', 200
  end

  # # User can view Profile
  # get '/user/profile/:id' do
  # end

  # # User can update Profile
  # patch '/user/profile/:id' do
  # end

  # Reset Password
  # get '/user/forgot_password' do
  # end
end
