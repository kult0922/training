class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  before_action :require_login

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    @task.user = current_user

    if @task.save
      redirect_to task_path(id: @task.id), notice: I18n.t('flash.create')
    else
      render :new
    end
  end

  def update
    if @task.update(task_params)
      redirect_to task_path(id: @task.id), notice: I18n.t('flash.updated')
    else
      render :edit
    end
  end

  def destroy
    if @task.present? && @task.destroy
      redirect_to tasks_path, notice: I18n.t('flash.destroy')
    else
      render :index
    end
  end

  def index
    @search_param = SearchParam.new(user_search_param)
    @tasks = Task.search(user_search_param, session[:current_user_id])
  end

  private
    def set_task
      @task = current_user.tasks.find(params[:id])
    end

    def task_params
      params.require(:task).permit(
        :name,
        :description,
        :labels,
        :status,
        :due_date
      )
    end

    def user_search_param
      params.fetch(:search, {}).permit(:status, :sort_order)
    end
end
