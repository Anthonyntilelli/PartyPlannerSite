class Party < ActiveRecord::Base
  belongs_to :venue
  belongs_to :theme
  belongs_to :user
  has_many :invites
  has_many :gifts

  validates_associated :theme
  validates_associated :venue
  validates_associated :user

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :user, presence: true
  validates :venue, presence: true
  validates :theme, presence: true
  validates :event_date, presence: true
  validates :time_slot,
            presence: true,
            numericality: { greater_than: 0, less_than: 5 }
  validate :active_theme_and_venue
  validate :correct_time

  # TODO: (LATER) validate venue time is free/other conflicting parties

  private

  # Venue  and Theme must be active
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
end
