# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :set_task, only: %i[show edit update destroy]
  before_action :set_user
  before_action :logged_in_user

  def index
    @tasks = @user.tasks.order(created_at: :desc).page(params[:page]).per(10)
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      redirect_to task_path(@task), success: I18n.t('flash.create_task')
    else
      flash.now[:danger] = I18n.t('flash.create_task_failed')
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @task.update(task_params)
      redirect_to task_path(@task), success: I18n.t('flash.update_task')
    else
      flash.now[:danger] = I18n.t('flash.update_task_failed')
      render :edit
    end
  end

  def destroy
    if @task.destroy
      redirect_to root_path, success: I18n.t('flash.destroy_task')
    else
      redirect_to root_path, danger: I18n.t('flash.destroy_task_failed')
    end
  end

  def search
    # 終了期限のソートorステータスorタスク名の検索
    @tasks = @user.tasks.deadline_sort(params[:deadline_keyword]).search_with_status(params[:status_keyword]).search_with_title(params[:title_keyword]).page(params[:page]).per(10)
  end

  private

  def set_task
    begin
      @task = current_user.tasks.find(params[:id])
    rescue => e
      redirect_to root_path, danger: I18n.t('flash.no_task')
    end
  end

  def set_user
    begin
      @user = current_user
    rescue => e
      redirect_to root_path, danger: I18n.t('flash.no_user')
    end
  end

  def task_params
    params.require(:task).permit(:user_id, :title, :description, :priority, :status, :deadline)
  end

  # ログイン済ユーザーかどうか確認
  def logged_in_user
    unless logged_in?
      flash[:danger] = I18n.t('flash.please_login')
      redirect_to login_path
    end
  end
end
