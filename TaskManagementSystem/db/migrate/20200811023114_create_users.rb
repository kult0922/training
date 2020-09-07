class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :last_name, null: false, limit: 25
      t.string :first_name, null: false, limit: 25
      t.string :email, null: false
      t.string :password_digest, null: false

      t.timestamps
    end
  end
end
