# frozen_string_literal: true

# Application controler Frontpage
class ApplicationController < Sinatra::Base
  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, 'secret'
    register Sinatra::Flash
  end

  get '/' do
    erb :welcome
  end

  get '/pry' do
    binding.pry
  end

  get '/gen_hmac' do
    HmacUtils.gen_url( $HOST + "/hmac/test", { 'email' => User.last.email }, 120)
  end

  get '/hmac/test' do
    return 'hmac Passed'
  end

  helpers do
    # Load user & returns user from session id
    def load_user_from_session
      User.find_by_id!(session['user_id'])
    end

    # returns user from email params
    def load_user_from_params_email
      User.find_by_email!(params['email']&.downcase)
    end

    # Check to ensure hmac validation was run
    def ensure_hmac_passed
      unless session['passed_hmac'] == params['salt']
        session.clear
        flash[:ERROR] = 'Hmac validation error'
        redirect to '/'
      end
    end

    # Tests is @user matches current_password
    # redirect to "/user/me" if incorrect password
    def require_reauthenticate
      return if @user&.authenticate(params['current_password'])

      flash[:ERROR] = 'Incorrect current password, operation aborted.'
      redirect to '/user/me', 403
    end
  end
end
