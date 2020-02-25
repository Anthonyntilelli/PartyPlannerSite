class CreateParties < ActiveRecord::Migration[5.2]
  def change
    create_table :parties do |t|
      t.integer :user_id, null: false
      t.integer :theme_id, null: false
      t.integer :venue_id, null: false
      t.datetime :start_datetime, null: false
      t.datetime :end_datetime, null: false
      t.timestamps
    end
    add_foreign_key :users, :parties
    add_foreign_key :themes, :parties
    add_foreign_key :venues, :parties
  end
end
