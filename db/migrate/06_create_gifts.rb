class CreateGifts < ActiveRecord::Migration[5.2]
  def change
    create_table :gifts do |t|
      t.integer :user_id, null: false
      t.integer :party_id, null: false
      t.text :name, null: false
      t.timestamps
    end
  end
end
