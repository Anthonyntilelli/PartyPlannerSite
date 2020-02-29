class Invite < ActiveRecord::Base
  belongs_to :user
  belongs_to :party

  validates_associated :user
  validates_associated :party

  validates :user, presence: true
  validates :party, presence: true
  validate :cannot_invite_self
  validates :internal_name, absence: true # Ensure not entered by user
  validate :set_internal_name
  # IMPORTANT: Keep after :set_internal_name
  validates :internal_name, uniqueness: { case_sensitive: false }
end

private

def set_internal_name
  self.internal_name = party.name + "=>" + user.email
end

def cannot_invite_self
  errors.add(:You, 'cannot invite yourself') if user.email.downcase == party.user.email.downcase
end
