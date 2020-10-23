class TasksController < ApplicationController
  def index
    @tasks = Task.all.order(created_at: :desc)
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    if @task.valid?
      @task.save
      redirect_to tasks_url, notice: I18n.t('tasks.flash.create', name: @task.name)
    else
      render :new
    end
  end

  def show
    @task = Task.find(params[:id])
  end

  def edit
    @task = Task.find(params[:id])
  end

  def update
    @task = Task.find(params[:id])
    if @task.update(task_params)
      redirect_to tasks_url, notice: I18n.t('tasks.flash.update', name: @task.name)
    else
      render :edit
    end
  end

  def destroy
    @task = Task.find(params[:id])
    @task.destroy
    redirect_to tasks_url, notice: I18n.t('tasks.flash.delete', name: @task.name)
  end

  private

  def task_params
    params.require(:task).permit(:name, :description, :end_date, :priority, :status)
  end
end