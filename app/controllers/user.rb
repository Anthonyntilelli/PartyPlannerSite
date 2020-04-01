# frozen_string_literal: true

# User controller with Sinatra
class UserController < ApplicationController
  # User signup Page
  get '/pre_user/user/signup' do
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
      @verify_link = HmacUtils.gen_url( $HOST + "/user/verify/#{user.id}", { 'email' => user.email }, 120)
      # Send email validation for user account
      EmailUtil.send_email(
        user.email,
        'Welcome to the party: Please verify you user account.', # Subject
        (erb :'/email/verify_account', layout: false) # Body
      )
    rescue ActiveRecord::RecordInvalid => e
      flash[:ERROR] = e.message
      redirect to '/user/signup', 400
    end
    flash[:SUCCESS] = "Signup Successfull: Welcome #{params['name']}, please view your email for confirm link."
    redirect to '/'
  end

  # Verify email owernship after signup
  get '/user/verify/:id' do
    validate_url_with_id
    # Valid User?
    if @user.email == params['email'].downcase
      @user.locked = false if @user.locked
      @user.save if @user.changed?
      redirect to '/', 200
    end
    flash[:ERROR] = 'Invalid user'
    redirect to '/', 403
  end

  # User can view Profile
  get '/authed/user/me' do
    # TODO: need to add '@user' back
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

  # Reset Password (page)
  get '/user/forgot_password' do
    erb :'/user/password_reset'
  end

  # Send Reset Link
  post '/user/forgot_password' do
    user = User.find_by_email(params['email'].downcase)
    if user.nil?
      flash[:ERROR] = 'Unknown User'
      redirect to '/user/forgot_password', 400
    end
    @reset_link = HmacUtils.gen_url( $HOST + "/user/reset_password/#{user.id}", {'email' => user.email }, 120)
    email_body = erb :'email/reset_password', layout: false
    # Send email validation for user account
    EmailUtil.send_email(user.email, 'Party Planner: Password Reset Link.', email_body)
    flash[:SUCCESS] = 'Reset Password email sent.'
    redirect to '/', 200
  end

  # Reset password (verfy link)
  get '/user/reset_password/:id' do
    validate_url_with_id
    if params['email'].downcase == @user.email
      session['reset_id'] = @user.id
      session['reset_expire'] = params['expire']
      erb :"user/reset_password"
    else
      flash[:ERROR] = 'Error with passwordless login, please try again later.'
      redirect to '/user/login', 400
    end
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
      user.locked = false
      begin
        user.update!(password: params['new_password'], password_confirmation: params['new_confirm_password'])
      rescue ActiveRecord::RecordInvalid => e
        flash[:ERROR] = e.message
        redirect to '/', 400
      else
        flash[:SUCCESS] = 'Password updated'
        redirect to '/'
      end
    else
      flash[:ERROR] = 'Invalid user or expired link'
      redirect to '/', 403
    end
  end
end
