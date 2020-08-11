class CreateAdmins < ActiveRecord::Migration[6.0]
  def change
    create_table :admins do |t|
      t.string :last_name
      t.string :first_name
      t.string :email
      t.string :password
      t.string :passowrd_digest

      t.timestamps
    end
  end
end
