# frozen_string_literal: true

require './config/environment'
# Application controler Frontpage
class ApplicationController < Sinatra::Base
  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
  end

  get '/' do
    @title = 'TODO: Frontpage'
    @header_text = 'TODO: Frontpage'
    @follow_up_paragraph = 'Follow up frontpage text'
    erb :welcome
  end
end
