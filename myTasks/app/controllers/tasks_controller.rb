class TasksController < ApplicationController
  def index
    @tasks = Task.all
  end

  def show
    @task = Task.find(params[:id])
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    
    if @task.save
      flash[:notice] = 'Create Task!'
      redirect_to '/'
    else
      flash[:alert] = 'Could not create the task.'
      render 'new'
    end
  end

  def edit
    @task = Task.find(params[:id])
  end

  def update
    @task = Task.find(params[:id])
    
    if @task.update(task_params)
      flash[:notice] = 'Update Task!'
      redirect_to '/'
    else
      flash[:alert] = 'Could not edit the task.'
      render 'edit'
    end
  end

  def destroy
    @task = Task.find(params[:id])
    if @task.destroy
      flash[:notice] = 'Delete Task!'
      redirect_to '/'
    end
  end

  private

  def task_params
    params.require(:task).permit(:name, :description, :end_date, :priority)
  end
end
