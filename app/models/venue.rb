# frozen_string_literal: true

# Model for Venues using Active Record
class Venue < ActiveRecord::Base
  has_many :parties
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :zipcode, presence: true, length: { is: 5 }, numericality: { only_integer: true }
  validates :state, presence: true, length: { is: 2 } # state shortcode
  # -1 char shortest city name and +5 char largest city name in USA
  validates :city, presence: true, length: { in: 2..50 }
  validates :street_addr, presence: true, uniqueness: { case_sensitive: false }
  # active validated in DB
end
