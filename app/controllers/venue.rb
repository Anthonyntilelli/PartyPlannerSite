# frozen_string_literal: true

# Venue controller using Sinatra
class VenueController < ApplicationController
  # view list of themes
  get '/admin/venue' do
    erb :'venue/list'
  end

  # view and edit venue
  get '/admin/venue/:id' do
    @venue = if params['id'] == 'new'
               Venue.new
             else
               get_venue(params['id'])
             end
    erb :'venue/edit_or_new'
  end

  # Create Venue
  post '/admin/venue/new' do
    begin
      venue = Venue.create!(
        name: params['venue_name'].titleize,
        zipcode: params['venue_zipcode'],
        state: params['venue_state'].upcase,
        city: params['venue_city'].titleize,
        street_addr: params['venue_street_addr'],
        active: params['active'] == 'yes'
      )
      flash['alert-success'] = "Venue Created: #{venue.name}"
      redirect to "/admin/venue/#{venue.id}"
    rescue ActiveRecord::RecordInvalid => e
      flash['alert-danger'] = e.message
      redirect to '/admin/venue', 400
    end
  end

  # Edit Venue
  patch '/admin/venue/:id' do
    begin
      venue = get_venue(params['id'])
      venue.update!(
        name: params['venue_name'].titleize,
        zipcode: params['venue_zipcode'],
        state: params['venue_state'].upcase,
        city: params['venue_city'].titleize,
        street_addr: params['venue_street_addr'],
        active: params['active'] == 'yes'
      )
      flash['alert-success'] = "Venue Updated: #{venue.name}"
      redirect to "/admin/venue/#{venue.id}"
    rescue ActiveRecord::RecordInvalid => e
      flash['alert-danger'] = e.message
      redirect to '/admin/venue', 400
    end
  end

  # show venue info
  get '/venue' do
    erb :'venue/view'
  end

  # Cannot delete venue only make inactive, venue are used by parties.

  helpers do
    # Finds theme based on Id or redirects to admin base page
    def get_venue(id)
      venue = Venue.find_by_id(id)
      return venue if venue

      # Not Found
      flash['alert-danger'] = 'Unable to find desired Venue'
      redirect to '/admin/venue', 404
    end
  end
end
