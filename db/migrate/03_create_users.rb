# frozen_string_literal: true

# Migration creating users table using Active Record
class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.text :name, null: false
      t.datetime :birthday # Optional
      t.text :email, null: false # username
      t.text :password_digest, null: false
      t.boolean :valid_email, null: false, default: false
      t.boolean :locked, null: false, default: false
      t.boolean :admin, null: false, default: false
      t.timestamps
    end
  end
end
