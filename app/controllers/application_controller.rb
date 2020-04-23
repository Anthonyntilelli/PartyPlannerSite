# frozen_string_literal: true

# Application controler Frontpage
class ApplicationController < Sinatra::Base
  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, ENV['PARTY_SESSION_KEY']
    register Sinatra::Flash
    use Rack::MethodOverride
    #  set :show_exceptions, false
  end

  get '/' do
    erb :welcome
  end

  not_found do
    erb :not_found
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

    # Returns nil instead of raise Error
    def wrapped_load_user_from_params_email
      User.find_by_email(params['email']&.downcase)
    end

    # Check to ensure hmac validation was run
    def ensure_hmac_passed
      return if session['passed_hmac'] == params['salt']

      session.clear
      flash['alert-danger'] = 'Hmac validation error'
      redirect to '/', 403
    end

    def hmac_id_match_user(user, id)
      return if id.to_i == user.id

      session.clear
      flash['alert-danger'] = 'Hmac failure, Please try again later'
      redirect to '/', 403
    end

    def delete_your_parties(party)
      party.invites.destroy_all # Remove related invites
      party.destroy # Delete party
    end
  end
end
