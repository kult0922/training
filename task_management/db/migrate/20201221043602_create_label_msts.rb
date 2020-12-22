class CreateLabelMsts < ActiveRecord::Migration[6.1]
  def change
    create_table :label_mst do |t|
      t.bigint  :user_id, comment: "ユーザID", null: false
      t.integer :no     , comment: "ラベルNo", null: false
      t.string  :name   , comment: "ラベル名", null: false
      t.timestamps null: false
    end
    add_index       :label_mst, [:user_id, :no], unique: true
    add_foreign_key :label_mst, :users_tbl, column: :user_id
  end
end
