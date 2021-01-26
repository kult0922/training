# frozen_string_literal: true

class Admin::UsersController < ApplicationController
  before_action :admin_check

  def index
    user_sort_params
    @users = User.users_with_tasks_count
                 .sorted(sort: params[:sort], direction: params[:direction])
                 .page(params[:page])
                 .per(10)
  end

  private

  def user_sort_params
    params.permit(:sort, :direction)
  end
end
