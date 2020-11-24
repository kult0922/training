class CreateUsers < ActiveRecord::Migration[6.0]
  def change
      create_table :users, { id: false } do |t|
      t.bigint :id
      t.varchar :password
      t.varchar :email
      t.datetime :created_at
      t.datetime :updated_at

      t.timestamps
    end
  end
end
