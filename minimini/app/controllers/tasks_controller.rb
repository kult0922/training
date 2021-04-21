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
    # 検索用
    @task = Task.new
    # 検索結果
    @tasks = Task.preload(:user).where(user_id: session[:current_user_id])
  end

  private
    # コールバック
    def set_task
      @task = current_user.tasks.find(params[:id])
    end

    # ホワイトリスト
    def task_params
      params.require(:task).permit(
        :name,
        :description,
        :labels,
        :status,
        :due_date
      )
    end
end
