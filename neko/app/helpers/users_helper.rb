module UsersHelper
  def admin?
    current_user.role.id == 1
  end
end
