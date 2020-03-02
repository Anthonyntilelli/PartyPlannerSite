# frozen_string_literal: true

# Migration creating themes table using Active Record
class CreateThemes < ActiveRecord::Migration[5.2]
  def change
    create_table :themes do |t|
      t.text :name, null: false
      t.boolean :active, null: false
      t.timestamps
    end
  end
end
