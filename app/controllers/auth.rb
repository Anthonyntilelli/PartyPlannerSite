# frozen_string_literal: true

# Contains before filter for auth requirments
# Auth pages (login pages), not for user manipulation
class AuthController < ApplicationController
  # --- Filters Start ---

  before "/authed/?*" do # TODO: REMOVE ME
    raise "depricated"
  end

  before "/pre_user/?*" do # TODO: REMOVE ME
    raise "depricated"
  end

  # Require login to access these sites.
  before '/post_auth/?*' do
    # Test for valid logged in user
    unless session['user_id'] && User.find_by_id(session[:user_id])
      session.clear
      flash[:ERROR] = 'Please log in'
      redirect to '/user/login', 403
    end
  end

  # redirect if logged_in
  before '/pre_auth/?*' do
    redirect to '/' if session['user_id']
  end

  #  Validate Hmac urls
  before '/hmac/?*' do
    unless HmacUtils.valid_hmac_url?(url, request.query_string)
      flash[:ERROR] = 'Invalid Link or Expired'
      redirect to '/', 403
    end
    session['passed_hmac'] = params['salt']
  end

  after do
    session.delete('passed_hmac')
  end
  # --- Filters End ---

  # User Login (password based)
  get '/pre_auth/login' do
    erb :'auth/login'
  end

  # Authenticate User via password
  post '/pre_auth/login' do
    user = load_user_from_params_email
    save_user_id_to_session(user) if user&.authenticate(params['password'])

    session.delete('user_id')
    flash[:ERROR] = 'Incorrect User or Password' unless flash[:Error]
    redirect to '/pre_auth/login', 403
  end

  # User passwordless Login
  get '/pre_auth/login/passwordless' do
    erb :'auth/login_passwordless'
  end

  # Start password login
  post '/pre_auth/login/passwordless' do
    user = load_user_from_params_email
    if user&.allow_passwordless
      unless user.locked
        link_body = $HOST + '/hmac/login/passwordless' + "/#{user.id}"
        @auth_link = HmacUtils.gen_url(link_body, { 'email' => user.email }, 8)
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
    redirect to '/pre_auth/login/passwordless', 403
  end

  # Authenite User Passwordless and set session.
  get '/hmac/login/passwordless/:id' do
    ensure_hmac_passed
    @user = load_user_from_params_email
    # double check correct user
    save_user_id_to_session(@user) if params['id'].to_i == @user.id && @user&.allow_passwordless

    session.clear
    flash[ERROR] = 'Passwordless login failure, Please try again later'
    redirect to '/'
  end

  # Logout by clearing session
  get '/logout' do
    session.clear
    flash[:SUCCESS] = 'You are Logged out.'
    redirect to '/', 200
  end

  helpers do
    # Save user to session if not locked
    def save_user_id_to_session(user)
      unless user.locked
        session['user_id'] = user.id
        redirect to '/', 200
      end
      flash[:ERROR] = 'Account is locked, please click \'Forgot my password\' to unlock'
      session.delete('user_id')
      redirect to '/pre_auth/login', 403
    end
  end
end
