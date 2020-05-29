class TasksController < ApplicationController
  before_action :set_task, only: %i[show edit update destroy]

  def index
    @tasks = Task.all.order(created_at: :desc)
  end

  def show; end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(tasks_params)
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
      @tasks = Task
        .order_by_due_date(params[:due_date_order]&.to_sym)
        .search_by_title(params[:title])
        .search_by_status(params[:status])
      render 'index'
    rescue
      redirect_to tasks_path, alert: t('tasks.search_form.search_error')
    end
  end

  private

  def tasks_params
    params.require(:task).permit(:title, :description, :priority, :status, :due_date)
  end

  def set_task
    @task = Task.find(params[:id])
    @title ||= @task.title
  end
end
