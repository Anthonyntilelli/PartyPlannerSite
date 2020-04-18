# frozen_string_literal: true

# User controller with Sinatra
class UserController < ApplicationController
  # User signup Page
  get '/pre_auth/user/signup' do
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
      full_url = request.base_url + "/hmac/user/verify/#{user.id}"
      @verify_link = HmacUtils.gen_url(full_url, { 'email' => user.email }, 120)
      # Send email validation for user account
      EmailUtil.send_email(
        user.email,
        'Welcome to the party: Please verify you user account.', # Subject
        (erb :'/email/verify_account', layout: false) # Body
      )
    rescue ActiveRecord::RecordInvalid => e
      flash[:ERROR] = e.message
      redirect to '/pre_auth/user/signup', 400
    end
    flash[:SUCCESS] = "Signup Successfull: Welcome #{params['name']}, please view your email for confirm link."
    redirect to '/'
  end

  # Verify email owernship after signup
  get '/hmac/user/verify/:id' do
    ensure_hmac_passed
    user = load_user_from_params_email
    hmac_id_match_user(user, params['id'])

    user.locked = false if user.locked
    user.save if user.changed?
    flash[:SUCCESS] = 'Email Verified'
    redirect to '/', 200
  end

  # User can view Profile
  get '/post_auth/user/me' do
    @user = load_user_from_session
    erb :"/user/profile"
  end

  # User can update Profile
  patch '/post_auth/user/modify/:modify' do |modify|
    @user = load_user_from_session
    begin
      case modify
      when 'name'
        @user.update!(name: params['new_name'])
        flash[:SUCCESS] = 'Name update Successfull.'
      when 'password'
        require_reauthenticate
        @user.update!(password: params['new_password'], password_confirmation: params['new_confirm_password'])
        flash[:SUCCESS] = 'Password update Successfull.'
      when 'passwordless'
        require_reauthenticate
        @user.update!(allow_passwordless: params['passwordless'] == 'yes')
        flash[:SUCCESS] = "Passwordless update to #{@user.allow_passwordless ? 'Enabled' : 'Disabled'}."
      else
        raise NotImplementedError, 'Unknown method, operation aborted.'
      end
    rescue ActiveRecord::RecordInvalid, NotImplementedError => e
      flash[:ERROR] = e.message
      redirect to '/post_auth/user/me', 400
    end
    @user.save if @user.changed?
    redirect to '/post_auth/user/me', 200
  end

  # Delete user account
  delete '/post_auth/user/me' do
    @user = load_user_from_session
    require_reauthenticate
    @user.destroy
    session.clear
    flash[:SUCCESS] = 'User Account Removed.'
    redirect to '/', 200
  end

  # Reset Password (page)
  get '/user/forgot_password' do
    erb :'/user/password_reset'
  end

  # Send Reset Link
  post '/user/forgot_password' do
    user = wrapped_load_user_from_params_email
    if user.nil?
      flash[:ERROR] = 'Unknown User'
      redirect to '/user/forgot_password', 400
    end
    @reset_link = HmacUtils.gen_url(
      request.base_url + "/hmac/user/reset_password/#{user.id}",
      { 'email' => user.email },
      120
    )
    email_body = erb :'email/reset_password', layout: false
    # Send email validation for user account
    EmailUtil.send_email(user.email, 'Party Planner: Password Reset Link.', email_body)
    flash[:SUCCESS] = 'Reset Password email sent.'
    redirect to '/', 200
  end

  # Reset password (verfy link)
  get '/hmac/user/reset_password/:id' do
    ensure_hmac_passed
    @user = load_user_from_params_email
    hmac_id_match_user(@user, params['id'])
    session['reset_id'] = @user.id
    session['reset_expire'] = params['expire']
    erb :"user/reset_password"
  end

  # Reset password and unlocks user
  patch '/user/reset_password' do
    reset_id = session.delete('reset_id')
    reset_expire = session.delete('reset_expire')
    # ensure session exist
    if reset_id.nil? || reset_expire.nil?
      flash[:ERROR] = 'Invalid Reset'
      redirect to '/', 403
    end
    user = User.find_by_id(reset_id)
    # if user exists & expire in range
    if user && (Time.now.utc <= Time.parse(reset_expire))
      begin
        user.update!(
          password: params['new_password'],
          password_confirmation: params['new_confirm_password'],
          locked: false
        )
      rescue ActiveRecord::RecordInvalid => e
        flash[:ERROR] = e.message
        redirect to '/', 400
      else
        user.save
        flash[:SUCCESS] = 'Password updated'
        redirect to '/'
      end
    end
    flash[:ERROR] = 'Invalid user or expired link'
    redirect to '/', 403
  end

  helpers do
    # Tests is @user matches current_password
    # redirect to "/post_auth/user/me" if incorrect password
    def require_reauthenticate
      return if @user&.authenticate(params['current_password'])

      flash[:ERROR] = 'Incorrect current password, operation aborted.'
      redirect to '/post_auth/user/me', 403
    end
  end
end
