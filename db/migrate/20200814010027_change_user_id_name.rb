class ChangeUserIdName < ActiveRecord::Migration[6.0]
  def change
    rename_column :tasks, :resiter_user_id, :register_user_id
  end
end
