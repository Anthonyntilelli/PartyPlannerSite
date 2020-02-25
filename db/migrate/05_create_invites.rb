class CreateInvites < ActiveRecord::Migration[5.2]
  def change
    create_table :invites do |t|
      t.integer :user_id, null: false
      t.integer :party_id, null: false
      t.boolean :accepted # True accepted, False declined, null no responce.
      t.timestamps
    end
    add_foreign_key :users, :invites
    add_foreign_key :parties, :invites
  end
end
