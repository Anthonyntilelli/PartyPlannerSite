class Theme < ActiveRecord::Base
  has_many :parties
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :active, presence: true
end
