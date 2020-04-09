# frozen_string_literal: true

# Party controller with Sinatra
class PartyController < ApplicationController
  # Create Party
  get '/post_auth/party/new' do
    erb :'party/new'
  end
  # Delete Party
  # Edit Party (E.g. Change Venue,date, time)
end
