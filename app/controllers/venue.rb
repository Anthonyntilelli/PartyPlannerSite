# frozen_string_literal: true

# Venue controller using Sinatra
class VenueController < ApplicationController
  # view list of themes
  get '/admin/venue' do
    erb :'venue/list'
  end

  # create new venue
  get '/admin/venue/new' do
    @venue = Venue.new
    erb :'venue/edit'
  end

  # view aand exit venue
  get '/admin/venue/:id' do
    @venue = get_venue(params['id'])
    erb :'venue/edit'
  end






  helpers do
    # Finds theme based on Id or redirects to admin base page
    def get_venue(id)
      venue = Venue.find_by_id(id)
      return venue if venue

      # Not Found
      flash[:ERROR] = 'Unable to find desired Venue'
      redirect to '/admin/main', 404
    end
  end
end
