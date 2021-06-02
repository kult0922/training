class AddIndexToLabelsUserIdName < ActiveRecord::Migration[6.1]
  def change
    change_column_null :labels, :name, false
    add_index :labels, [:user_id, :name], unique: true
  end
end
