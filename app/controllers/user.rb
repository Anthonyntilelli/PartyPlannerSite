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

  # User signup Page
  get '/user/signup' do
    # already logged in
    redirect_if_logged_in
    erb :"user/signup"
  end

  # Create User account
  post '/user/signup' do
    begin
      user = User.create!(
        name: params['name'],
        email: params['email'].downcase,
        email_confirmation: params['email_confirmation'].downcase,
        password: params['password'],
        password_confirmation: params['password_confirmation'],
        allow_passwordless: params['passwordless'] == 'yes',
        locked: true,
        admin: false
      )
      verify_link = HmacUtils.gen_url( $HOST + "/user/verify/#{user.id}", {'email' => user.email }, 120)
      email_body = <<-BODY

      Please click below to start using party Planner (Link expires in 2 hours).
      #{verify_link}
      You’re receiving this email because you signed up for Party Planner.
      This is an automated email.

      BODY

      # Send email validation for user account
      EmailUtil.send_email(
        user.email,
        'Welcome to the party: Please verify you user account.',
        email_body
      )
    rescue ActiveRecord::RecordInvalid => e
      flash[:ERROR] = e.message
      redirect to '/user/signup', 400
    end
    flash[:SUCCESS] = "Signup Successfull: Welcome #{params['name']}, please view your email for confirm link."
    redirect to '/'
  end

  # Verify email owernship after signup
  get '/user/verify/:id' do |id|
    query = params.to_h
    query.delete('id') # 'id' was not in original params
    unless HmacUtils.valid_url?($HOST + request.path, query)
      flash[:ERROR] = 'Invalid Link or Expired'
      redirect to '/', 403
    end
    # Valid User?
    user = User.find_by_id(id)
    if user.email == query['email']
      user.locked = false if user.locked
      user.save if user.changed?
      redirect to '/', 200
    end
    flash[:ERROR] = 'Invalid user'
    redirect to '/', 403
  end

  # User Login
  get '/user/login' do
    redirect_if_logged_in # already logged in
    erb :"user/login"
  end

  # # User password Login
  # get '/user/login/passwordless' do
  #   redirect_if_logged_in # already logged in
  #   erb :"user/login_passwordless"
  # end

  # Authenticate User
  post '/user/login' do
    user = User.find_by(email: params['email'])
    if user&.authenticate(params['password'])
      if !user.locked
        session['user_id'] = user.id
        session['login_time'] = Time.now.utc.to_s
        redirect to '/', 200
      else
        session['user_id'] = nil
        session['login_time'] = nil
        flash[:ERROR] = 'Account is locked, please click \'Forgot my password\' to unlock'
        redirect to '/user/login', 403
      end
    else
      flash[:ERROR] = 'Incorrect User or Password'
      redirect to '/user/login', 403
    end
    halt 404
  end

  # Start password login
  # post '/user/login/passwordless' do
  # end

  # # Authenite User Passwordless
  # get '/user/login/passwordless/:id' do |id|
  # end

  # Logout and clears session
  get '/user/logout' do
    session.clear
    flash[:SUCCESS] = 'You are Logged out.'
    redirect to '/', 200
  end

  # User can view Profile
  get '/user/me' do
    require_login
    erb :"/user/profile"
  end

  # User can update Profile
  patch '/user/me' do
    require_login
    if params['change_password']
      require_reauthenticate
      begin
        @user.update!(
          password: params['new_password'],
          password_confirmation: params['new_confirm_password']
        )
      rescue ActiveRecord::RecordInvalid => e
        flash[:ERROR] = e.message
        redirect to '/user/me', 400
      end
      flash[:SUCCESS] = 'Password update Successfull.'
    end

    if params['change_name']
      begin
        @user.update!(name: params['new_name'])
      rescue ActiveRecord::RecordInvalid => e
        flash[:ERROR] = e.message
        redirect to '/user/me', 400
      end
      flash[:SUCCESS] = 'Name update Successfull.'
    end

    if params['change_passwordless']
      require_reauthenticate
      begin
        @user.update!(allow_passwordless: params['passwordless'] == 'yes')
      rescue ActiveRecord::RecordInvalid => e
        flash[:ERROR] = e.message
        redirect to '/user/me', 400
      end
      flash[:SUCCESS] = "Passwordless update to #{@user.allow_passwordless ? 'Enabled' : 'Disabled'}."
    end

    @user.save user.save if @user.changed?
    redirect to '/user/me', 200
  end

  # Delete user account
  delete '/user/me' do
    require_login
    require_reauthenticate
    @user.destroy
    session.clear
    flash[:SUCCESS] = 'User Destroyed.'
    redirect to '/', 200
  end

  # Reset Password when forgot
  # get '/user/forgot_password' do
  # end

  helpers do
    # Test for valid logged in user and sets @user
    def require_login
      if session['user_id'] && User.find_by_id(session[:user_id])
        @user = User.find_by_id(session[:user_id])
      else
        session.clear
        flash[:ERROR] = 'Please log in'
        redirect to '/user/login', 403
      end
    end

    # Tests is @user matches current_password
    # redirect to "/user/me" if incorrect password
    def require_reauthenticate
      return if @user&.authenticate(params['current_password'])

      flash[:ERROR] = 'Incorrect current password, operation aborted.'
      redirect to '/user/me', 403
    end

    def redirect_if_logged_in
      redirect to '/' if session['user_id']
    end
  end
end
