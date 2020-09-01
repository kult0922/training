class CreateTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :tasks do |t|
      t.string :title, null: false, comment: 'タスク名'
      t.text :discription, comment: 'タスク説明文'

      t.timestamps
    end
  end
end
