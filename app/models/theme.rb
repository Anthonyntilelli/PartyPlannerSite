class Theme < ActiveRecord::Base
  has_many :parties
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  # active validated in DB
end
