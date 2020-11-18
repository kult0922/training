module Admin::UsersHelper

  def task_count(user)
    task_counts[user.id] ? task_counts[user.id] : 0
  end

  private

  def task_counts
    @task_counts ||= User.joins(:tasks).group(:user_id).count(:user_id)
  end

end
