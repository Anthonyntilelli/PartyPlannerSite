class User < ActiveRecord::Base
  has_many :invites
  has_many :gifts
  has_many :parties

  validates :name, presence: true
  # validates :birthday # TODO: validate date once see format
  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, length: { minimum: 8 }
  has_secure_password
  validates :valid_email, presence: true
  validates :locked, presence: true
  validates :admin, presence: true
end
