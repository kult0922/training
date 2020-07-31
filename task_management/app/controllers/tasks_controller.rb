class TasksController < ApplicationController
  helper_method :sort_column, :sort_direction

  before_action :set_task, only: %i[show edit update destroy]

  def index
    @search_params = {
      title: params[:title], status: params[:status], label_ids: params[:label_ids],
      sort_column: sort_column, sort_direction: sort_direction,
    }
    @tasks = current_user.tasks.search(@search_params).page(params[:page])
  end

  def show
  end

  def new
    @task = Task.new
    @task.task_labels.build
  end

  def create
    @task = current_user.tasks.new(task_params)
    if @task.save
      redirect_to tasks_path, notice: I18n.t('tasks.flash.create')
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @task.update(task_params)
      redirect_to tasks_path, notice: I18n.t('tasks.flash.update')
    else
      render :edit
    end
  end

  def destroy
    @task.destroy if redirect_to tasks_path, notice: I18n.t('tasks.flash.destroy')
  end

  private

  def task_params
    params.require(:task).
      permit(:title, :priority, :status, :due, :description, { label_ids: [] })
  end

  def set_task
    @task = current_user.tasks.find(params[:id])
  end

  def sort_direction
    %w(asc desc).include?(params[:direction]) ? params[:direction] : 'desc'
  end

  def sort_column
    Task.column_names.include?(params[:sort]) ? params[:sort] : 'created_at'
  end
end
