class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :password_digest, null: false
      t.string :api_key, null: false

      t.timestamps
    end

    add_index :users, :email, unique: true
  end
end
