class CreateRoles < ActiveRecord::Migration[6.0]
  def change
    create_table :roles do |t|
      t.string :name, null: false, limit: 25

      t.timestamps
    end
  end
end
