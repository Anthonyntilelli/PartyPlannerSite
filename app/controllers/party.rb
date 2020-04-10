# frozen_string_literal: true

# Party controller with Sinatra
class PartyController < ApplicationController
  # Create Party
  get '/post_auth/party/new' do
    erb :'party/new'
  end

  post '/post_auth/party/new' do
    user = load_user_from_session
    begin
      party = Party.create!(
        name: params['name'],
        user: user,
        venue: Venue.find_by_id!(params['venue']),
        theme: Theme.find_by_id!(params['theme']),
        event_date: params['partydate'], # yyyy-mm-dd
        time_slot: params['time_slot']
      )
    rescue ActiveRecord::RecordInvalid => e
      flash[:ERROR] = e.message
      redirect to '/post_auth/party/new', 400
    end
    flash[:SUCCESS] = 'Party Successfully Created: We will see you there!'
    redirect to "/post_auth/party/#{party.id}"
  end

  # View Party
  get '/post_auth/party/:party_id' do end

  # Edit party (E.g. Change Venue,date, time)
  get '/post_auth/party/:party_id/edit' do end

  # Delete Party
  delete '/post_auth/party/:party_id' do end
end
