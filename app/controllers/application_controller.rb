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

  get '/pry' do
    binding.pry
  end

  get "/hmac" do
    HmacUtils.gen_url('/vhmac', params.to_h)
  end

  get '/vhmac' do
    valid = HmacUtils.valid_url?(request.path, params.to_h)
    return "Result = #{valid}"
  end
end
