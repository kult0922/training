class CreateLabelMst < ActiveRecord::Migration[6.1]
  def change
    create_table :label_mst, id: false do |t|
      t.bigint  :label_mst_id, comment: "ラベルマスタID" , null: false, primary_key: true
      t.bigint  :user_id     , comment: "ユーザID"       , null: false
      t.integer :label_no    , comment: "ラベルNo"       , null: false
      t.string  :label_name  , comment: "ラベル名"       , null: false
    end
    add_index       :label_mst, [:user_id, :label_no], unique: true
    add_foreign_key :label_mst, :users_tbl, column: :user_id, primary_key: :users_tbl_id
  end
end
