class CreateAuthorityMsts < ActiveRecord::Migration[6.1]
  def change
    create_table :authority_mst do |t|
      t.integer :div , comment: "権限区分"    , null: false, limit: 1
      t.string  :name, comment: "権限名"      , null: false
      t.timestamps null: false
    end
    add_index :authority_mst, :div, unique: true
  end
end
