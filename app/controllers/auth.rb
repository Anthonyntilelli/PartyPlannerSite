# frozen_string_literal: true

# Contains before filter for auth requirments
# Auth pages (login pages), not for user manipulation
class AuthController < Sinatra::Base
  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    set :session_secret, 'secret'
    enable :sessions
    register Sinatra::Flash
    use Rack::MethodOverride # Method overwrite
  end

  # --- Filters Start ---
  # Require loggin to access these sites.
  before '/authed/?*' do
    # Test for valid logged in user
    if session['user_id'] && User.find_by_id(session[:user_id])
      # indicate before auth run
      # session['before_authed'] = true
    else
      session.clear
      flash[:ERROR] = 'Please log in'
      redirect to '/user/login', 403
    end
  end

  # redirect if logged_in
  before '/pre_user/?*' do
    redirect to '/' if session['user_id']
  end

  before '/hmac/?*' do
    # TODO
    raise NotImplementedError
  end

  # after do
  #   session.delete('before_authed')
  # end
  # --- Filters End ---

  # User Login (password based)
  get '/pre_user/login' do
    erb :'auth/login'
  end

  # Authenticate User via password
  post '/pre_user/login' do
    user = User.find_by_email(params['email'].downcase)
    if user&.authenticate(params['password'])
      if !user.locked
        session['user_id'] = user.id
        redirect to '/', 200
      else
        flash[:ERROR] = 'Account is locked, please click \'Forgot my password\' to unlock'
      end
    end
    session.delete('user_id')
    flash[:ERROR] = 'Incorrect User or Password' unless flash[:Error]
    redirect to '/pre_user/login', 403
  end

  # User passwordless Login
  get '/pre_user/login/passwordless' do
    erb :'auth/login_passwordless'
  end

  # Start password login
  post '/pre_user/login/passwordless' do
    user = User.find_by(email: params['email'].downcase)
    if user&.allow_passwordless
      unless user.locked
        @auth_link = HmacUtils.gen_url($HOST + request.path + "/#{user.id}", { 'email' => user.email }, 8)
        # Send email validation for user account
        EmailUtil.send_email(
          user.email,
          'Time to Party: Login Link to you user account.', # subject
          (erb :'email/passwordless_login', layout: false) # body
        )
        flash[:SUCCESS] = 'Please see email for access link'
        redirect to '/', 200
      end
      flash[:ERROR] = 'Account is locked, please click \'Forgot my password\' to unlock'
    end
    session.delete('user_id')
    flash[:ERROR] = 'Incorrect User or Passwordless not allowed on that user.' unless flash[:ERROR]
    redirect to '/pre_user/login/passwordless', 403
  end

  # TODO: Broken
  # Authenite User Passwordless and set session.
  get '/pre_user/login/passwordless/:id' do
    validate_url_with_id # TODO: Broken
    # TODO: ensure password less is allowed again
    if params['email'].downcase == @user.email
      session['user_id'] = @user.id
      redirect to '/', 200
    else
      flash[:ERROR] = 'Error with passwordless login, please try again later.'
      redirect to '/pre_user/login', 400
    end
  end

  # Logout by clearing session
  get '/logout' do
    session.clear
    flash[:SUCCESS] = 'You are Logged out.'
    redirect to '/', 200
  end
end
