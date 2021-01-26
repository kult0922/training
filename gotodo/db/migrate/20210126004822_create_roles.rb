class CreateRoles < ActiveRecord::Migration[6.1]
  def change
    create_table :roles do |t|
      t.string :name, limit: 10, null: false
      t.integer :no, limit: 1, null: false
      t.timestamps
    end
  end
end
