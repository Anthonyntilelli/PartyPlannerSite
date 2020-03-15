class RemoveValidEmailFromUser < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :valid_email, :boolean
  end
end
