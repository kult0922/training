# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :set_task, only: %i[show edit update destroy]
  before_action :logged_in_user
  before_action :current_user

  def index
    @project = Project.find(params[:project_id])
    @tasks = @project.tasks.eager_load(:assignee, :reporter)
    .where('assignee_id = ? OR reporter_id = ? ', @current_user, @current_user)
    .order(created_at: :desc)
    .page(params[:page]).per(20)
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
      flash.now[:error] = I18n.t('flash.failed', model: 'タスク', action: '作成')
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
      flash.now[:error] = I18n.t('flash.failed', model: 'タスク', action: '更新')
      render :edit, locals: { users: @users }
    end
  end

  def destroy
    if @task.destroy
      flash[:notice] = I18n.t('flash.succeeded', model: 'タスク', action: '削除')
      redirect_to project_tasks_path
    else
      flash.now[:error] = I18n.t('flash.failed', model: 'タスク', action: '削除')
      render :index
    end
  end

  def search
    @project = Project.find(params[:project_id])
    @tasks = tasks_search(@project).page(params[:page]).per(20)
    render :index
  end

  private def tasks_search(project)
    @order_by = sort_direction
    project.tasks.eager_load(:assignee, :reporter)
      .where('assignee_id = ? OR reporter_id = ? ', @current_user, @current_user)
      .name_search(params[:name])
      .status_search(params[:status_search])
      .priority_search(params[:priority_search])
      .order_finished_at(@order_by)
      .order(created_at: :desc)
  end

  private def sort_direction
    %w[asc desc].include?(params[:order_by]) ? params[:order_by] : nil
  end

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:task_name, :project_id, :priority, :assignee_id, :reporter_id, :description, :started_at, :finished_at, :status)
  end
end
