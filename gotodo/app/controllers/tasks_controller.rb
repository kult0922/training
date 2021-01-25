# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :set_task, only: %i[show edit update destroy]

  def index
    @tasks = Task.where(user_id: @current_user.id)
                 .task_search(title: params[:title], status: params[:status], sort: params[:sort], direction: params[:direction])
                 .page(params[:page])
                 .per(10)
    @partial = 'task'
  end

  def show
  end

  def new
    @task = Task.new
  end

  def edit
  end

  def create
    @task = @current_user.tasks.new(task_params)
    if @task.save
      redirect_to root_path, success: I18n.t('flash.create_success', model: I18n.t('activerecord.models.task'))
    else
      flash.now[:danger] = I18n.t('flash.create_error', model: I18n.t('activerecord.models.task'))
      render :new
    end
  end

  def update
    if @task.update(task_params)
      redirect_to @task, success: I18n.t('flash.update_success', model: I18n.t('activerecord.models.task'))
    else
      flash.now[:danger] = I18n.t('flash.update_error', model: I18n.t('activerecord.models.task'))
      render :edit
    end
  end

  def destroy
    @task.destroy
    redirect_to root_url, success: I18n.t('flash.destroy_success', model: I18n.t('activerecord.models.task'))
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_task
    @task = Task.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def task_params
    params.require(:task).permit(:title, :detail, :end_date, :status)
  end
end
