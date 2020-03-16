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
    @title = 'Party Planning, inc'
    @header_text = 'Party Planning, inc'
    @follow_up_paragraph = 'Best Place to Schedule your Party!'
    erb :welcome
  end

  # get "/pry" do
  #   binding.pry
  # end

end
