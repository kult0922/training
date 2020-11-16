class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :user_name, limit: 100
      t.string :password, limit: 100
      t.integer :roll, limit: 2

      t.timestamps
    end
  end
end
