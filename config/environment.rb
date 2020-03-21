# frozen_string_literal: true

raise 'Missing Send Grid key from ENV' unless ENV['SENDGRID_API_KEY']

ENV['SINATRA_ENV'] ||= 'development'

require 'bundler/setup'
require 'sinatra/flash'
require 'resolv'
Bundler.require(:default, ENV['SINATRA_ENV'])

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: "db/#{ENV['SINATRA_ENV']}.sqlite"
)

require './app/controllers/application_controller'
require_all 'app'
