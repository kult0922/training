class CreateAuthInfos < ActiveRecord::Migration[6.0]
  def change
    create_table :auth_infos do |t|
      t.string :email, null: false
      t.string :password_digest, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
