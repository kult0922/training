class Admins::Users::TasksController < ApplicationController

  def index
    @user = User.find(params[:user_id])
    @tasks = @user.tasks.order(created_at: :desc).page(params[:page]).per(10)
  end
end