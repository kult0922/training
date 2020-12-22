class CreateAuthorityMst < ActiveRecord::Migration[6.1]
  def change
    create_table :authority_mst, id: false do |t|
      t.bigint :authority_mst_id           , comment: "権限マスタID", null: false, primary_key: true
      t.column :authority_div   ,:"CHAR(1)", comment: "権限区分"    , null: false
      t.string :authority_name             , comment: "権限名"      , null: false
    end
    add_index :authority_mst, :authority_div, unique: true
  end
end
