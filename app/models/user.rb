class User < ActiveRecord::Base
  has_many :invites
  has_many :gifts
  has_many :parties
  has_secure_password
end
