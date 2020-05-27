class AddIndexToAuthInfo < ActiveRecord::Migration[6.0]
  def change
    add_index :auth_infos, :email, unique: true
  end
end
