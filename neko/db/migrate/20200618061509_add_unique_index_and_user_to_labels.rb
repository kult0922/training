class AddUniqueIndexAndUserToLabels < ActiveRecord::Migration[6.0]
  def change
    add_index  :labels, :name, unique: true
    add_reference :labels, :user,　null: false, foreign_key: true
  end
end
