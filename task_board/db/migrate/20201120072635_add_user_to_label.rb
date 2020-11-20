class AddUserToLabel < ActiveRecord::Migration[6.0]
  def up
    add_reference :labels, :user, index: true
    add_foreign_key :labels, :users
  end

  def down
    remove_reference :labels, :user, index: true
    remove_foreign_key :labels, :users
  end
end
