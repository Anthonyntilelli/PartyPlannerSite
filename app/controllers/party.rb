# frozen_string_literal: true

# Party controller with Sinatra
class PartyController < ApplicationController
  # Create Party (page)
  get '/post_auth/party/new' do
    erb :'party/new'
  end

  # Creates party
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

  # List all parties user created
  get '/post_auth/party' do
    @user = load_user_from_session
    # List of all parties created by user
    @user_hosted = Party.all.find_all { |party| party.user == @user }
    # TODO: List of all parties this user is invited to
    erb :'party/view_all'
  end

  # View a Party
  get '/post_auth/party/:party_id' do
    load_user_and_party(true)
    erb :'party/view'
  end

  # Edit party (page)
  get '/post_auth/party/:party_id/edit' do
    load_user_and_party
    erb :'party/new_edit'
  end

  # Edit party (TODO)
  patch '/post_auth/party/:id' do
    load_user_and_party
    # TODO: Edit party
  end

  # Delete Party
  delete '/post_auth/party/:party_id' do end

  helpers do
    # Load user via session id and party
    # Sets @user and @party
    # Enforces permissions
    def load_user_and_party(allow_invitees = false)
      @user = load_user_from_session
      begin
        @party = Party.find_by_id!(Integer(params['party_id']))
        # allow owner
        return if @user == @party.user
        # Allow invitees
        return if allow_invitees && @party.invites.any? { |invite| invite.user == @user }
      rescue ArgumentError, ActiveRecord::RecordNotFound
        # Expected error on on valid_url, simply 404 below
      end

      # Not allowed
      flash[:ERROR] = 'Invalid Party'
      redirect to '/', 404
    end

    # Converts time code number into proper time of day
    def time_slot_to_date(time_slot)
      case time_slot
      when 1
        'Morning'
      when 2
        'Afternoon'
      when 3
        'Evening'
      when 4
        'Latenight'
      end
    end
  end
end
