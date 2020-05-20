module UsersHelper
  def admin?
    @current_user.role.name == '管理ユーザー'
  end
end