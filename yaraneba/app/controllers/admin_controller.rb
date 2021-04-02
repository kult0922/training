# frozen_string_literal: true

class AdminController < ApplicationController
  before_action :reject_unless_admin

  def user
    @users = User.left_joins(:role).left_joins(:tasks).select('users.id, users.email, roles.role_name, count(tasks.id) as tasks_count').group(:id)
  end

  def task
    @tasks = Task.joins(:user).select('tasks.*, users.email')
  end

  def new
    redirect_to controller: :users, action: :new
  end

  def user_new
    @user = User.new
    render template: 'admin/user_new'
  end

  def user_create
    @user = User.new(user_params)
    if User.find_by(email: @user.email, deleted_at: nil).present? || @user.invalid?
      redirect_to admin_users_new_path, alert: I18n.t('notice.fault')
    else
      @user.save
      redirect_to admin_users_path, notice: I18n.t('notice.success')
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :role_id)
  end
end
