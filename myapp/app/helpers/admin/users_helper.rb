module Admin::UsersHelper
  def is_admin_button_show?
    user = User.find(@current_user.user_id)
    signed_in? && user.admin?
  end
end