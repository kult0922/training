class TaskController < ApplicationController
  def index
    task_status_id = params[:task_status_id]
    if !task_status_id.blank?
      @task = Task.where(task_status_id: task_status_id)
    else
      @task = Task.all
    end
    @status_selection = task_status_list
    @status_selection.store('全て', '')
  end

  def new
     @task = Task.new
     @status_selection = task_status_list
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      flash[:notice] = 'New task created!'
      redirect_to root_path
    else
      render 'new'
    end
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
    @status_selection = task_status_list
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
    params.require(:task).permit(:title, :description, :task_status_id)
  end

  def task_status_list
    TaskStatus.all.map{ |status| [status.name, status.id] }.to_h
  end