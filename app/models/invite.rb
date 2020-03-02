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
  validates :party, presence: true
  validate :cannot_invite_self

  private

  def cannot_invite_self
    errors.add(:You, 'cannot invite yourself') if user.email.downcase == party.user.email.downcase
  end
end
