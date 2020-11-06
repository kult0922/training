class CreateTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :tasks do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title
      t.text :description
      t.datetime :expire_date
      t.integer :status
      t.integer :priority

      t.timestamps
    end
  end
end
