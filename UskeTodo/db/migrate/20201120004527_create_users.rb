class CreateUsers < ActiveRecord::Migration[6.0]
  def change
      create_table :users, { id: false } do |t|
      t.bigint :id
      t.string :password
      t.string :email
      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end
