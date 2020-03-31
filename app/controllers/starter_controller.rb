# frozen_string_literal: true

# Contains before filter
class StarterController < Sinatra::Base
  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    set :session_secret, 'secret'
    enable :sessions
    register Sinatra::Flash
    use Rack::MethodOverride # Method overwrite

    before '/authed/?*' do
      binding.pry
      # Test for valid logged in user
      if session['user_id'] && User.find_by_id(session[:user_id])
        # indicate before auth run
        session['before_authed'] = true
      else
        session.clear
        flash[:ERROR] = 'Please log in'
        redirect to '/user/login', 403
      end
    end

    before '/pre_user/?*' do
      # redirect if logged_in
      redirect to '/' if session['user_id']
    end

    after do
      session.delete('before_authed')
    end
  end
end
