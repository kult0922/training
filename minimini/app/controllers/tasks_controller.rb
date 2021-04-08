class TasksController < ApplicationController
  protect_from_forgery
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  def new
    @task = Task.new()
    @task.user_id = session[:user_id]
    # 動作確認用
    @task.due_date = Date.today
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
    @tasks = Task.searchAll(session["user_id"])
  end

  private
    # コールバック
    def set_task
      if params[:id] == nil
        @task = Task.find(params[:task][:id])
      else 
        @task = Task.find(params[:id])
      end
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
