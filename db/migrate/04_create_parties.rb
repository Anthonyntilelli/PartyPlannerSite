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
  end
end
