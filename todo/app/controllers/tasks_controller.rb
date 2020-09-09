# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :set_task, only: %i[show edit update destroy]
  before_action :logged_in_user
  before_action :current_user
  before_action :check_task_auth, only: %i[show edit destroy]

  def index
    @project = Project.find(params[:project_id])
    @order_by = sort_direction
    @tasks = @project.tasks.search(search_params).page(params[:page])
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
      if add_user_to_project(@task.assignee) && add_user_to_project(@task.reporter)
        flash[:notice] = I18n.t('flash.succeeded', model: 'タスク', action: '作成')
        redirect_to [@task.project, @task]
      else
        flash[:error] = I18n.t('flash.failed', model: 'ユーザプロジェクト', action: '作成')
        redirect_to project_tasks_url(@task.project)
        return
      end
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
      if add_user_to_project(@task.assignee) && add_user_to_project(@task.reporter)
        flash[:notice] = I18n.t('flash.succeeded', model: 'タスク', action: '作成')
        redirect_to [@task.project, @task]
      else
        flash[:error] = I18n.t('flash.failed', model: 'ユーザプロジェクト', action: '作成')
        redirect_to project_tasks_url(@task.project)
        return
      end
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

  private

  def sort_direction
    %w[asc desc].include?(params[:order_by]) ? params[:order_by] : nil
  end

  def check_task_auth
    redirect_to project_tasks_url unless [@task.assignee_id, @task.reporter_id].include?(session[:user_id])
  end

  def add_user_to_project(user)
    begin
      return if user.projects.ids.include?(user)
      @task.project.users << user
    rescue
      return false
    end
    true
  end

  def set_task
    @task = Task.find(params[:id])
  end

  def search_params
    @search_params = { user_id: current_user, task_name: params[:name], priority: params[:priority_search], status: params[:status_search], order_by: sort_direction }
  end

  def task_params
    params.require(:task).permit(:task_name, :project_id, :priority, :assignee_id, :reporter_id, :description, :started_at, :finished_at, :status)
  end
end
