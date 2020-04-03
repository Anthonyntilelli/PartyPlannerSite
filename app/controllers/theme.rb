# frozen_string_literal: true

# Them controller using Sinatra
class ThemeController < ApplicationController
  # view adn exit theme
  get '/admin/theme/:id' do
    @theme = get_theme(params['id'])
    erb :'theme/edit'
  end

  # Modify Theme
  patch '/admin/theme/:id' do end

  # delete theme
  delete '/admin/theme/:id' do end

  helpers do
    # Finds theme based on Id or redirects to admin base page
    def get_theme(id)
      theme = Theme.find_by_id(id)
      return theme if theme

      # Not Found
      flash[:ERROR] = 'Unable to find desired Theme'
      redirect to '/admin/main', 404
    end

  end
end
