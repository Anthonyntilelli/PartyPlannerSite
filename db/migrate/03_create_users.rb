class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.text :first_name, null: false
      t.text :last_name, null: false
      t.datetime :birthday # Optional
      t.text :email, null: false # username
      t.text :password_digest, null: false
      t.boolean :validated, null: false, default: false
      t.boolean :locked, null: false, default: false
      t.boolean :admin, null: false, default: false
      t.timestamps
    end
  end
end
