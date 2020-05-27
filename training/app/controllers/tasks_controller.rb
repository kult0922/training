class TasksController < ApplicationController
  before_action :set_task, only: %i[show edit update destroy]

  def index
    @tasks = Task.all
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
    @tasks = Task.order_by_priority(params[:priority_order].to_sym)
    render 'index'
  end

  private

  def tasks_params
    params.require(:task).permit(:title, :description, :priority, :status, :due_date)
  end

  def set_task
    @task = Task.find(params[:id])
  end
end
