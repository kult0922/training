# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :set_task, only: %i[show edit update destroy]

  def index
    @project = Project.find(params[:project_id])
    @order_by = sort_direction
    @tasks = @project.tasks
             .order_finished_at(@order_by)
             .order(created_at: :desc)
  end

  def show
  end

  def new
    @users = User.all
    @task = Project.find(params[:project_id]).tasks.new
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      redirect_to [@task.project, @task]
      flash[:notice] = I18n.t('flash.succeeded', model: 'タスク', action: '作成')
    else
      @users = User.all
      flash[:error] = I18n.t('flash.failed', model: 'タスク', action: '作成')
      render :new, locals: { users: @users }
    end
  end

  def edit
    @users = User.all
  end

  def update
    if @task.update(task_params)
      flash[:notice] = I18n.t('flash.succeeded', model: 'タスク', action: '更新')
      redirect_to [@task.project, @task]
    else
      @users = User.all
      flash[:error] = I18n.t('flash.failed', model: 'タスク', action: '更新')
      render :edit, locals: { users: @users }
    end
  end

  def destroy
    if @task.destroy
      flash[:notice] = I18n.t('flash.succeeded', model: 'タスク', action: '削除')
      redirect_to project_tasks_path
    else
      flash[:error] = I18n.t('flash.failed', model: 'タスク', action: '削除')
      render :index
    end
  end

  private

  def sort_direction
    %w[asc desc].include?(params[:order_by]) ? params[:order_by] : nil
  end

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:task_name, :project_id, :priority, :assignee_id, :reporter_id, :description, :started_at, :finished_at)
  end
end
