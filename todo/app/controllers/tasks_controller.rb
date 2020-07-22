# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :set_task, only: %i[show edit update destroy]

  def index
    @pjid = params[:project_id]
    @tasks = Task.where(project_id: @pjid)
  end

  def show
    @assignee_user = User.find_by(id: @task.assignee_id)
    @assignee_username = @assignee_user.account_name
    @reporter_user = User.find_by(id: @task.reporter_id)
    @reporter_username = @reporter_user.account_name
  end

  def new
    @users = User.all
    @task = Task.new
    @pjid = params[:project_id]
    @project = Project.where(id: @pjid)
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      redirect_to @task
      flash[:notice] = 'タスクが作成されました。'
    else
      render :new
      flash[:error] = 'タスク作成に失敗しました。'
    end
  end

  def edit
    @task = Task.find(params[:id])
    @users = User.all
    @pjid = params[:project_id]
    @project = Project.where(id: @task.project_id)
  end

  def update
    if @task.update(task_params)
      flash[:notice] = 'タスクが更新されました。'
      redirect_to @task
    else
      flash[:error] = 'タスクが更新に失敗しました。'
      render :edit
    end
  end

  def destroy
    @task = Task.find(params[:id])
    if @task.destroy
      flash[:notice] = 'タスクが削除されました。'
      redirect_to tasks_path(project_id: @task.project_id)
    else
      flash[:error] = 'タスクが削除されませんでした。'
      render :edit
    end
  end

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:task_name, :project_id, :priority, :assignee_id, :assignee_name, :reporter_id, :reporter_name, :description, :started_at, :finished_at)
  end
end
