# frozen_string_literal: true

# Theme controller using Sinatra
class ThemeController < ApplicationController
  # view adn exit theme
  get '/admin/theme/:id' do
    @theme = get_theme(params['id'])
    erb :'theme/edit'
  end

  # Modify Theme
  patch '/admin/theme/:id/:field' do
    @theme = get_theme(params['id'])
    begin
      case params['field']
      when 'name'
        @theme.update!(name: params['new_name'].capitalize )
        flash[:SUCCESS] = 'Name update Successfull.'
      when 'active'
        @theme.update!(active: params['active'] == 'yes')
        flash[:SUCCESS] = 'Active update Successfull.'
      else
        raise NotImplementedError, 'Unknown method, Operation aborted.'
      end
    rescue ActiveRecord::RecordInvalid, NotImplementedError => e
      flash[:ERROR] = e.message
      redirect to "/admin/theme/#{params['id']}", 400
    end
    @theme.save if @theme.changed?
    redirect to "/admin/theme/#{params['id']}", 200
  end

  # delete theme
  delete '/admin/theme/:id' do
    @theme = get_theme(params['id'])
    @theme.destroy

    flash[:SUCCESS] = 'Theme removed.'
    redirect to '/admin/main', 200
  end

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
