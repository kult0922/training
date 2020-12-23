class CreateAuthorities < ActiveRecord::Migration[6.1]
  def change
    create_table :authorities do |t|
      t.integer :role, comment: "権限区分"    , null: false, limit: 1
      t.string  :name, comment: "権限名"      , null: false
      t.timestamps null: false
    end
    add_index :authorities, :role, unique: true
  end
end
