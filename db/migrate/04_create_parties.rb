class CreateParties < ActiveRecord::Migration[5.2]
  def change
    create_table :parties do |t|
      t.string :name, null: false
      t.integer :user_id, null: false
      t.integer :theme_id, null: false
      t.integer :venue_id, null: false
      t.date :event_date, null: false
      t.integer :time_slot, null: false
      t.timestamps
    end
  end
end
