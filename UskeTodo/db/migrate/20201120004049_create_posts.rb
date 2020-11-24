class CreatePosts < ActiveRecord::Migration[6.0]
  def change
      create_table :posts, { id: false } do |t|
      t.bigint :id
      t.varchar :title
      t.text :detail
      t.datetime :created_at
      t.datetime :updated_at

      t.timestamps
    end
  end
end
