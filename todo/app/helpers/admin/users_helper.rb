module Admin::UsersHelper
  def admin?(user)
    user.admin == true
  end
end
