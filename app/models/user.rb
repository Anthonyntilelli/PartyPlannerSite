# frozen_string_literal: true

class User < ActiveRecord::Base
  has_many :invites
  has_many :gifts
  has_many :parties

  validates :name, presence: true
  validates :email,
            presence: true,
            uniqueness: { case_sensitive: false },
            format: { with: URI::MailTo::EMAIL_REGEXP },
            confirmation: true
  validates :email_confirmation, presence: true, if: -> { email_changed? }
  validates :password,
            presence: true,
            length: { minimum: 8 },
            if: -> { password_digest_changed? }
  validates :password_confirmation,
            presence: true,
            if: -> { password_digest_changed? }
  validate :email_not_password, if: -> { password_digest_changed? }
  has_secure_password
  # active valid_email, locked, admin validated in DB

  private

  def email_not_password
    errors.add(:password, 'must not equal email') if password.downcase == email.downcase
  end
end
