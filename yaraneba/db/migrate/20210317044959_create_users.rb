class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :email
      t.string :password_digest
      t.datetime :deleted_at, limit: 6

      t.timestamps
    end
  end
end
