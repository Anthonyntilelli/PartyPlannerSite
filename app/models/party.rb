class Party < ActiveRecord::Base
  belongs_to :venue
  belongs_to :theme
  belongs_to :user
  has_many :invites
  has_many :gifts

  validates_associated :theme
  validates_associated :venue
  validates_associated :user

  validates :user, presence: true
  validates :venue, presence: true
  validates :theme, presence: true
  validates :start_datetime, presence: true
  validates :end_datetime, presence: true

  # TODO: Theme must be active
  # TODO: Venue must be active
  # TODO: VALIDATE start/end_datetime are at least 3 days in future
  # TODO: (LATER) validate venue time is free/other conflicting parties
end
