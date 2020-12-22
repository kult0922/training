class CreateLabels < ActiveRecord::Migration[6.1]
  def change
    create_table :labels do |t|
      t.bigint  :user_id, comment: "ユーザID", null: false
      t.string  :name   , comment: "ラベル名", null: false
      t.timestamps null: false
    end
    add_foreign_key :labels, :users, column: :user_id
  end
end
