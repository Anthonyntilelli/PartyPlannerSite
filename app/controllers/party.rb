# frozen_string_literal: true

# Party controller with Sinatra
class PartyController < ApplicationController
  # List all parties user created
  get '/post_auth/party' do
    @user = load_user_from_session
    # Parties user is hosting
    @user_hosted = Party.all.find_all { |party| party.user == @user }
    # Party from Invites
    @user_invited = @user.invites.all.find_all { |invite| invite.user == @user }
    erb :'party/view_all'
  end

  # Create Party (page)
  get '/post_auth/party/new' do
    @party = Party.new
    erb :'party/new_edit'
  end

  # Creates party
  post '/post_auth/party/new' do
    user = load_user_from_session
    begin
      Party.create!(
        name: params['name'].titleize,
        user: user,
        venue: Venue.find_by_id!(params['venue']),
        theme: Theme.find_by_id!(params['theme']),
        event_date: params['partydate'], # yyyy-mm-dd
        time_slot: params['time_slot']
      )
    rescue ActiveRecord::RecordInvalid => e
      flash['alert-danger'] = e.message
      redirect to '/post_auth/party/new', 400
    end
    flash['alert-success'] = 'Party Successfully Created: We will see you there!'
    redirect to '/post_auth/party'
  end

  # Edit party (page)
  get '/post_auth/party/:party_id' do
    load_user_and_party
    erb :'party/new_edit'
  end

  # Edit party
  patch '/post_auth/party/:party_id' do
    load_user_and_party
    begin
      @party.update!(
        name: params['name'].titleize,
        user: @user,
        venue: Venue.find_by_id!(params['venue']),
        theme: Theme.find_by_id!(params['theme']),
        event_date: params['partydate'], # yyyy-mm-dd
        time_slot: params['time_slot']
      )
      flash['alert-success'] = "Party Updated: #{@party.name}"
      redirect to "/post_auth/party/#{@party.id}"
    rescue ActiveRecord::RecordInvalid => e
      flash['alert-danger'] = e.message
      redirect to "post_auth/party/#{params['party_id']}", 400
    end
  end

  # Delete party and related invites and gifts
  delete '/post_auth/party/:party_id' do
    load_user_and_party
    delete_your_parties(@party)
    flash['alert-success'] = 'Party removed.'
    redirect to '/post_auth/party', 200
  end

  # ---- Party Invites ----

  # Manage Invites
  get '/post_auth/party/:party_id/invites' do
    load_user_and_party
    erb :'party/manage_invites'
  end

  # Add Invites
  post '/post_auth/party/:party_id/invites/new' do
    load_user_and_party
    exit_code = 400 # Start at error
    begin
      invited_user = load_user_from_params_email
    rescue ActiveRecord::RecordNotFound
      invited_user = nil
      flash['alert-danger'] = 'Invited person does not have an account. Please try again, once they have an account.'
    end
    if invited_user
      begin
        invite = Invite.create!(user: invited_user, party: @party, status: 'pending')
        flash['alert-success'] = "Invite sent to #{invite.user.name}"
        exit_code = 200
      rescue ActiveRecord::RecordInvalid => e
        flash['alert-danger'] = e.message
      end
    end
    redirect to "/post_auth/party/#{@party.id}/invites", exit_code
  end

  # Accepts or Declines Invite
  get '/post_auth/invite/:invite_id/:action' do
    # permission control
    @user = load_user_from_session
    exit_code = 404
    begin
      @invite = Invite.find_by_id!(params['invite_id'])
    rescue ArgumentError, ActiveRecord::RecordNotFound
      flash['alert-danger'] = 'Invite Invalid.'
    end
    if @invite&.status == 'pending'
      begin
        @invite.update!(status: params['action'])
        flash['alert-success'] = "Invite #{params['action']}."
        exit_code = 200
      rescue ActiveRecord::RecordInvalid => e
        flash['alert-danger'] = e.message
        exit_code = 400
      end
    else
      flash['alert-danger'] = 'Invite is no longer pending.'
    end

    redirect to '/post_auth/party', exit_code
  end

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
        # Expected error on valid urls, simply 404 below
      end

      # Not allowed
      flash['alert-danger'] = 'Invalid Party'
      redirect to '/', 404
    end
  end
end
