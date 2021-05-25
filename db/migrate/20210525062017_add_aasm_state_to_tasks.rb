class AddAasmStateToTasks < ActiveRecord::Migration[6.1]
  def change
    add_column :tasks, :aasm_state, :integer
  end
end
