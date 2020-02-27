class CreateVenues < ActiveRecord::Migration[5.2]
  def change
    create_table :venues do |t|
      t.text :name, null: false
      t.integer :zipcode, null: false
      t.text :state, null:false
      t.text :city, null:false
      t.text :street_addr, null: false
      t.boolean :active, null: false
      t.timestamps
    end
  end
end
