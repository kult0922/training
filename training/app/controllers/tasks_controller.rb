class TasksController < ApplicationController
  before_action :set_task, only: %i[show edit update destroy]
  before_action :restrict_own_task, only: %i[show edit update destroy]

  def index
    @tasks = current_user.tasks.order(created_at: :desc).page(params[:page])
  end

  def show; end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(**tasks_params, user_id: current_user.id)
    if @task.save
      redirect_to tasks_path, notice: t('tasks.flash.create')
    else
      render :new
    end
  end

  def edit; end

  def update
    if @task.update(tasks_params)
      redirect_to tasks_path, notice: t('tasks.flash.update')
    else
      render :edit
    end
  end

  def destroy
    @task.destroy!
    redirect_to tasks_path, notice: t('tasks.flash.delete')
  end

  def search
    begin
      @tasks = current_user.tasks
        .order_by_due_date(params[:due_date_order].to_sym)
        .search_by_title(params[:title])
        .search_by_status(params[:status])
        .page(params[:page])
      render 'index'
    rescue
      redirect_to tasks_path, alert: t('tasks.search_form.search_error')
    end
  end

  private

  def tasks_params
    params.require(:task).permit(:title, :description, :priority, :status, :due_date, label_ids: [])
  end

  def set_task
    @task = Task.find(params[:id])
    @title ||= @task.title
  end

  def restrict_own_task
    task_user_id = Task.find(params[:id]).user_id
    return if current_user.id == task_user_id
    redirect_to root_path, alert: t('tasks.flash.restrict_own_task')
  end
end
