class Gift < ActiveRecord::Base
  has_one :user
  belongs_to :party
end
