# frozen_string_literal: true

# Remove birthday column from User table
class RemoveBirthdayFromUser < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :birthday, :datetime
  end
end
