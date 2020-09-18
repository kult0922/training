# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :find_task_by_id, only: %i[show edit update destroy]
  before_action :logged_in_user

  PER = 5

  def index
    @q = Task.ransack(params[:q])
    load_tasks
  end

  def new
    @task = Task.new
    load_user
  end

  def show
  end

  def edit
    @task = Task.new
    load_user
  end

  def create
    @task = Task.new(permitted_tasks_params)
    if @task.save
      redirect_to controller: :tasks, action: :index, notice: I18n.t('tasks.controller.messages.created')
    else
      flash.now[:notice] = I18n.t('tasks.controller.messages.failed_to_create')
      render 'new'
    end
  end

  def update
    @user = User.find(params[:user_id])
    if @task.update(permitted_tasks_params)
      redirect_to controller: :tasks, action: :index, notice: I18n.t('tasks.controller.messages.edited')
    else
      flash.now[:notice] = I18n.t('tasks.controller.messages.failed_to_edited')
      render 'edit'
    end
  end

  def destroy
    @task.destroy!
    redirect_to user_tasks_path(@current_user.id), notice: I18n.t('tasks.controller.messages.deleted')
  end

  private

  def permitted_tasks_params
    params.require(:task).permit(
      :title,
      :description,
      :due_date,
      :status,
    ).merge(
      user_id: params[:user_id],
    )
  end

  def find_task_by_id
    @task = Task.find(params[:id])
  end

  def load_tasks
    @tasks = @q.result(distinct: true
    ).where(
      user_id: @current_user.id,
    ).sort_task_by(
      params[:sort],
      params[:direction],
    ).page(params[:page]).per(PER)
  end

  def load_user
    @user = User.find(params[:user_id])
  end
end
