class InsertInitialRoles < ActiveRecord::Migration[6.0]
  def change
    roles = ['管理ユーザー', '一般ユーザー']
    roles.each do |r|
      Role.create(name: r)
    end
  end
end
