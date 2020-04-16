# frozen_string_literal: true

ENV['SINATRA_ENV'] ||= 'development'
$HOST = 'http://127.0.0.1:9393'

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
