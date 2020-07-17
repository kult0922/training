# frozen_string_literal: true

class AddUniquenessConstraintToAppUser < ActiveRecord::Migration[6.0]
  def change
    # overflow unique key limit without this line
    change_column :app_users, :name, :string, { limit: 100 }
    add_index :app_users, [:name], unique: true, name: 'idx_app_user_unique_name'
  end
end
