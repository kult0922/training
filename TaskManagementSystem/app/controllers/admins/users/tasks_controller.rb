# frozen_string_literal: true

class Admins::Users::TasksController < ApplicationController
  before_action :admin_user_initialize
  before_action :user_initialize, only: :index

  def index
    @tasks = @user.tasks.order(created_at: :desc).page(params[:page]).per(10)
  end
end
