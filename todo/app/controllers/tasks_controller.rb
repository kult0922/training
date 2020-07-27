# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :set_task, only: %i[show edit update destroy]

  def index
    @project = Project.find(params[:project_id])
    @tasks = @project.tasks
  end

  def show
  end

  def new
    @users = User.all
    @task = Task.new
    @project = Project.find(params[:project_id])
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
    @users = User.all
    @project = @task.project
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
    if @task.destroy
      flash[:notice] = 'タスクが削除されました。'
      redirect_to tasks_path(project_id: @task.project_id)
    else
      flash[:error] = 'タスクが削除されませんでした。'
      render :index
    end
  end

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:task_name, :project_id, :priority, :assignee_id, :reporter_id, :description, :started_at, :finished_at)
  end
end
