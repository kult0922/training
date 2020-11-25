class CreatePosts < ActiveRecord::Migration[6.0]
  def change
      create_table :posts, { id: false } do |t|
      t.bigint :id
      t.string :title
      t.text :detail
      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end
