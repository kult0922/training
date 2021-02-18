class ChangeColumnToAuthority < ActiveRecord::Migration[6.1]
  def up
    change_column :authorities, :role, :integer,
                  comment: "権限区分" , null: false
  end

  def down
    change_column :authorities, :role, :integer,
                  comment: "権限区分" , null: false, limit: 1
  end
end
