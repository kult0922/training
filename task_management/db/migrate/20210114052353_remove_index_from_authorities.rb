class RemoveIndexFromAuthorities < ActiveRecord::Migration[6.1]
  def change
    remove_index :authorities, :role
  end
end
