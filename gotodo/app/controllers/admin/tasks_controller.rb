# frozen_string_literal: true

module Admin
  class TasksController < AdminController
    helper TasksHelper

    def index
      @tasks = Task.where(user_id: params[:id])
                   .task_search(params)
                   .page(params[:page])
                   .per(10)
      @user = User.find(params[:id])
      render template: 'tasks/index'
    end
  end
end
