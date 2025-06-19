class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :email_address, null: false
      t.string :password_digest, null: false
      t.string :username, null: false
      t.integer :role, default: 0, null: false
      t.timestamps
    end
    add_index :users, [ :email_address, :username ], unique: true
  end
end
