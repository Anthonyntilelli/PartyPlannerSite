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
end
