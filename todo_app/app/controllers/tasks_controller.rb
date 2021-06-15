class TasksController < ApplicationController

  before_action :find_task, only: [:edit, :update, :show, :destroy]

  def index
    @tasks = Task.all
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    if @task.save!
      flash[:success] = t('tasks.flash.success.create')
      redirect_to root_path
    end
  end

  def update
    @task.update!(task_params)

    flash[:success] = t('tasks.flash.success.update')
    redirect_to task_path(@task)
  end

  def destroy
    @task.delete

    flash[:success] = t('tasks.flash.success.destroy')
    redirect_to root_path
  end

  private

  def task_params
    params.require(:task).permit(:title, :description)
  end

  def find_task
    @task = Task.find_by(id: params[:id])
  end
end
