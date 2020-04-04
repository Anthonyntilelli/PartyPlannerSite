# frozen_string_literal: true

# Contains before filter for auth requirments
# Auth pages (login pages), not for user manipulation
class AuthController < ApplicationController
  # --- Filters Start ---

  # Require login to access these sites.
  before '/post_auth/?*' do
    check_logged_in
  end

  # redirect if logged_in
  before '/pre_auth/?*' do
    redirect to '/' if session['user_id']
  end

  #  Validate Hmac urls
  before '/hmac/?*' do
    halt 403, 'Hmac path only supports GET verb' if request.env['REQUEST_METHOD'] != 'GET'

    unless HmacUtils.valid_get_url?(url, request.query_string)
      flash[:ERROR] = 'Invalid Link or Expired'
      redirect to '/', 403
    end
    session['passed_hmac'] = params['salt']
  end

  before '/admin/?*' do
    check_logged_in
    # Must be admin
    return if User.find_by_id(session[:user_id]).admin

    flash[:ERROR] = 'Only admin allowed on this page'
    redirect to '/', 403
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
    user = wrapped_load_user_from_params_email
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
    user = wrapped_load_user_from_params_email
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
    hmac_id_match_user(@user, params['id'])
    # double check allowed
    save_user_id_to_session(@user) if @user&.allow_passwordless

    # passwordless not allowed
    flash[ERROR] = 'Passwordless login failure, Please try again later'
    redirect to '/', 400
  end

  # Logout by clearing session
  get '/logout' do
    session.clear
    flash[:SUCCESS] = 'You are Logged out.'
    redirect to '/', 200
  end

  # TODO: Implement
  # Admin Main Page
  get '/admin/main' do
    raise NotImplementedError
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

    # Test for valid logged in user
    def check_logged_in
      return if session['user_id'] && User.find_by_id(session[:user_id])

      session.clear
      flash[:ERROR] = 'Please log in'
      redirect to '/pre_auth/login', 403
    end
  end
end
