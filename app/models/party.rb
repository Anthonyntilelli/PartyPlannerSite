class Party < ActiveRecord::Base
  belongs_to :venue
  belongs_to :theme
  belongs_to :user
end
