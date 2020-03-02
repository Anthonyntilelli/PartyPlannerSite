# frozen_string_literal: true

# Model for Parties using Active Record
class Party < ActiveRecord::Base
  belongs_to :venue
  belongs_to :theme
  belongs_to :user
  has_many :invites
  has_many :gifts

  validates_associated :theme
  validates_associated :venue
  validates_associated :user

  # Each User must have unique party names
  validates :name, presence: true, uniqueness: { case_sensitive: false, scope: :user_id }
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

  private

  # Venue and Theme must be active
  def active_theme_and_venue
    errors.add(:theme, 'must be active') unless theme.active
    errors.add(:venue, 'must be active') unless venue.active
  end

  # Enforce event_date range
  def correct_time
    min = Date.current + 3.days
    max = Date.current + 1.year
    errors.add(:event_date, "must be set after #{min}") unless min < event_date
    errors.add(:event_date, "must be set before #{max}") unless max > event_date
  end

  def no_other_party_at_same_venu_time_slot_and_event_date
    existing = Party.find_by(venue: venue, time_slot: time_slot, event_date: event_date)
    if existing && existing.id != id # rubocop:todo Style/GuardClause
      errors.add(:Another_Party, 'already exists at that venue, date, and time slot.')
    end
  end
end
