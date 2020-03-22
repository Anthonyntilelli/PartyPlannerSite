# frozen_string_literal: true

require './config/environment'
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

  # get '/send_email' do
  #   EmailUtil.send_email(
  #     'anthony@tilelli.me',
  #     'Test email from send_email',
  #     "I am the body from send_email\n"
  #   )
  #   erb :welcome
  # end

  # get '/pry' do
  #   binding.pry
  #   # HmacUrl.gen_url(request.host + ':9393' + request.path, params.to_h)
  # end
end
