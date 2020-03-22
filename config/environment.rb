# frozen_string_literal: true

$HOST = '127.0.0.1:9393'
raise 'Missing Send Grid key from ENV' unless ENV['SENDGRID_API_KEY']
raise 'Missing URL HMAC  key from ENV' unless ENV['HMAC_URl_KEY']

ENV['SINATRA_ENV'] ||= 'development'

require 'bundler/setup'
require 'sinatra/flash'
require 'uri'
require 'resolv'
require 'securerandom'
require 'sendgrid-ruby'
Bundler.require(:default, ENV['SINATRA_ENV'])

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: "db/#{ENV['SINATRA_ENV']}.sqlite"
)

require './app/controllers/application_controller'
require_all 'app'
