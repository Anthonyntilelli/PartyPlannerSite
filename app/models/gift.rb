# frozen_string_literal: true

# Model for Gifts using Active Record
class Gift < ActiveRecord::Base
  belongs_to :user
  belongs_to :party

  validates_associated :user
  validates_associated :party
  validates :name, presence: true
  validates :party, presence: true
end
