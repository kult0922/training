class CreateRoles < ActiveRecord::Migration[6.1]
  def change
    create_table :roles do |t|
      t.string :role_name
      t.datetime :deleted_at, limit: 6

      t.timestamps
    end
  end
end
