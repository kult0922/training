class TaskController < ApplicationController
  def index
    @task = Task.all
  end

  def new
  end

  def create
    # render plain: params[:task].inspect
    @task = Task.new(task_params)
    @task.save
    redirect_to @task
  end

  def show
    @task = Task.find(params[:id])
  end

  def update
    @task = Task.find(params[:id])
    if @task.update(task_params)
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

    redirect_to task_index_path
  end
end

private
  def task_params
    params.require(:task).permit(:title, :description)
  end
