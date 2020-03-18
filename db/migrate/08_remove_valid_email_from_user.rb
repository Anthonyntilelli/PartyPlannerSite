# frozen_string_literal: true

# Removed valid user column from users (redundent for locked)
class RemoveValidEmailFromUser < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :valid_email, :boolean
  end
end
