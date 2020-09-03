# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :set_task, only: %i[show edit update destroy]
  before_action :logged_in_user
  before_action :current_user
  before_action :check_task_auth, only: %i[show edit destroy]
  before_action :set_labels, only: %i[show new create update edit index]
  before_action :hash_labels, only: %i[new edit create update index]

  def index
    @project = Project.find(params[:project_id])
    @order_by = sort_direction
    @tasks = tasks_search
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
      create_user_project(@task.assignee_id)
      create_user_project(@task.reporter_id)
      redirect_to [@task.project, @task]
      flash[:notice] = I18n.t('flash.succeeded', model: 'タスク', action: '作成')
    else
      @users = User.all
      flash.now[:error] = I18n.t('flash.failed', model: 'タスク', action: '作成')
      render :new
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
      render :edit
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

  def tasks_search
    load_task
      .name_search(params[:name])
      .status_search(params[:status_search])
      .priority_search(params[:priority_search])
  end

  def load_task
    @project.tasks.eager_load(:assignee, :reporter)
      .eager_load(:labels)
      .where('assignee_id = ? OR reporter_id = ? ', @current_user, @current_user)
      .order_by_at(sort_direction)
      .label_search(params[:label_ids])
      .page(params[:page]).per(20)
  end

  def sort_direction
    %w[asc desc].include?(params[:order_by]) ? params[:order_by] : nil
  end

  def check_task_auth
    redirect_to project_tasks_url unless [@task.assignee_id, @task.reporter_id].include?(session[:user_id])
  end

  def create_user_project(user)
    return if UserProject.find_by(user_id: user, project_id: @task.project_id).present?
    user_project = UserProject.new(user_id: user, project_id: @task.project_id)
    flash[:error] = I18n.t('flash.failed', model: 'ユーザプロジェクト', action: '作成') unless user_project.save
  end

  def set_task
    @task = Task.find(params[:id])
  end

  def set_labels
    @labels = Label.all
  end

  def hash_labels
    @hash = {}
    @labels.each do |label|
      @hash.store(label.color, label.text)
    end
  end

  def task_params
    params.require(:task).permit(:task_name, :project_id, :priority, :assignee_id, :reporter_id, :description, :started_at, :finished_at, :status, { label_ids: [] })
  end
end
