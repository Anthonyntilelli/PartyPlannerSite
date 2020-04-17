# frozen_string_literal: true

# Model for Invite using Active Record
class Invite < ActiveRecord::Base
  belongs_to :user
  belongs_to :party

  validates_associated :user
  validates_associated :party

  validates :user,
            presence: true,
            uniqueness: {
              case_sensitive: false,
              scope: :party_id, message: 'was already invited.'
            }
  validates :status, presence: true
  validates :party, presence: true
  validate :cannot_invite_self
  validate :allowed_status

  private

  def cannot_invite_self
    errors.add(:You, 'cannot invite yourself') if user.email.downcase == party.user.email.downcase
  end

  # Check if status is the correct string
  def allowed_status
    errors.add(:string, 'must be pending, accepted or declined.') unless %w[pending accepted declined].any?(status)
  end
end
