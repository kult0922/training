# frozen_string_literal: true

class Admins::Users::TasksController < ApplicationController
  before_action :admin_user_initialize
  before_action :user_initialize, only: :index
  def index
    @tasks = @user.tasks.order(created_at: :desc).page(params[:page]).per(10)
  end

  private

  def user_initialize
    @user = User.find(params[:user_id])
  rescue StandardError => e
    redirect_to admins_users_path, danger: I18n.t('flash.no_user')
  end
end
