# frozen_string_literal: true

class Admins::Users::TasksController < ApplicationController
  before_action :admin_user
  before_action :set_user, only: :index
  def index
    @tasks = @user.tasks.order(created_at: :desc).page(params[:page]).per(10)
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  rescue StandardError => e
    redirect_to admins_users_path, danger: I18n.t('flash.no_user')
  end
end
