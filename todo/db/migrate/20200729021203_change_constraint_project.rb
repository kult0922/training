class ChangeConstraintProject < ActiveRecord::Migration[6.0]
  def up
    change_column :projects, :started_at, :date, null: false
    change_column :projects, :finished_at, :date, null: false
  end

  def down
    change_column :projects, :started_at, :date
    change_column :projects, :finished_at, :date
  end
end
