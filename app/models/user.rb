# frozen_string_literal: true

# Model for Users using Active Record
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
  validate :check_mx_record
  has_secure_password
  # allow_passwordless, locked and admin validated in DB

  private

  def email_not_password
    errors.add(:password, 'must not equal email') if password.downcase == email.downcase
  end

  # Ensure provided email domain has MX record
  def check_mx_record
    domain = email.split('@').last
    results = Resolv::DNS.open { |dns| dns.getresources(domain, Resolv::DNS::Resource::IN::MX) }
    errors.add(:email, 'domain does not support email (no MX record).') if results.empty?
  end
end
