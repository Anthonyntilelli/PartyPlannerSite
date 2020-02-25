class CreateVenues < ActiveRecord::Migration[5.2]
  def change
    create_table :venues do |t|
      t.text :name, null: false
      t.text :location, null: false
      t.boolean :active, null: false
      t.timestamps
    end
  end
end
