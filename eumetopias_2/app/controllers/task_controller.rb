class TaskController < ApplicationController
  def index
    @task = Task.all
  end

  def new
  end

  def create
    @task = Task.create(task_params)
    flash[:notice] = 'New task created!'
    redirect_to @task
  end

  def show
    unless @task = Task.find_by(id: params[:id])
      flash[:notice] = 'Task not found'
      redirect_to root_path
    end
  end

  def update
    @task = Task.find(params[:id])
    if @task.update(task_params)
      flash[:notice] = 'Task updated!'
      redirect_to @task
    else
      render 'edit'
    end
  end

  def edit
    @task = Task.find(params[:id])
  end

  def destroy
    @task = Task.find(params[:id])
    @task.destroy
    flash[:notice] = 'Task deleted!'
    redirect_to root_path
  end
end

private
  def task_params
    params.require(:task).permit(:title, :description)
  end
