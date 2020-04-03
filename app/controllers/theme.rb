# frozen_string_literal: true

# Them controller using Sinatra
class ThemeController < ApplicationController

  # view adn exit theme
  get '/admin/theme/:id' do end

  # Modify Theme
  patch '/admin/theme/:id' do end

  # delete theme
  delete '/admin/theme/:id' do end
end
