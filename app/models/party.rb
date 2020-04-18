# frozen_string_literal: true

# Model for Parties using Active Record
class Party < ActiveRecord::Base
  belongs_to :venue
  belongs_to :theme
  belongs_to :user
  has_many :invites

  validates_associated :theme
  validates_associated :venue
  validates_associated :user

  # Each User must have unique party names
  validates :name,
            presence: true,
            uniqueness: { case_sensitive: false, scope: :user_id },
            length: { minimum: 5 }
  validates :user, presence: true
  validates :venue, presence: true
  validates :theme, presence: true
  validates :event_date, presence: true
  validates :time_slot,
            presence: true,
            numericality: { greater_than: 0, less_than: 5 }
  validate :active_theme_and_venue
  validate :correct_time
  validate :no_other_party_at_same_venu_time_slot_and_event_date

  # Converts time code number into proper time of day
  def self.time_slot_to_date(time_slot)
    case time_slot
    when 1
      'Morning'
    when 2
      'Afternoon'
    when 3
      'Evening'
    when 4
      'Latenight'
    end
  end

  # Earliest day allowed for new parties
  def self.earliest_date
    Date.current + 3.days
  end

  # Latest day allowed for new parties
  def self.latest_date
    Date.current + 1.year
  end

  private

  # Venue and Theme must be active
  def active_theme_and_venue
    errors.add(:theme, 'must be active') unless theme.active
    errors.add(:venue, 'must be active') unless venue.active
  end

  # Enforce event_date range
  def correct_time
    earliest = Party.earliest_date
    latest = Party.latest_date
    errors.add(:event_date, "must be set at or after #{earliest}") unless earliest <= event_date
    errors.add(:event_date, "must be set at or before #{latest}") unless latest >= event_date
  end

  def no_other_party_at_same_venu_time_slot_and_event_date
    existing = Party.find_by(venue: venue, time_slot: time_slot, event_date: event_date)
    return unless existing && existing.id != id

    errors.add(:Another_Party, 'already exists at that venue, date, and time slot.')
  end
end
