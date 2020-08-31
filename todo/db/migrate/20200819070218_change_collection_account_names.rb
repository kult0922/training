class ChangeCollectionAccountNames < ActiveRecord::Migration[6.0]
  def up
    execute("ALTER TABLE users MODIFY account_name varchar(255) BINARY")
  end
end
