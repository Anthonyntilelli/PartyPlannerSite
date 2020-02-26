class Party < ActiveRecord::Base
  belongs_to :venue
  belongs_to :theme
  belongs_to :user
  has_many :invites
  has_many :gifts
end
