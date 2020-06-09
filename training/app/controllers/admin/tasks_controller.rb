class Admin::TasksController < Admin::Base
  def index
    user = User.find(params[:user_id])
    @tasks = user.tasks.order(created_at: :desc)
  end
end
