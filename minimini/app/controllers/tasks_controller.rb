class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  before_action :require_login

  def new
    @task = Task.new()
    @task.user_id = session[:user_id]
  end

  def create
    @task = Task.new(task_params)
    
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
      render :list
    end
  end

  def index
    # 検索用
    @task = Task.new()
    # 検索結果
    @tasks = Task.all.preload(:user).where(user_id: session["user_id"])
  end

  private
    # コールバック
    def set_task
      @task = Task.find(params[:id])
    end

    # ホワイトリスト
    def task_params
      params.require(:task).permit(
        :user_id,
        :id,
        :name,
        :description,
        :labels,
        :status,
        :due_date
      )
    end
end
