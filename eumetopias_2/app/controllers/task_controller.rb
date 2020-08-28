class TaskController < ApplicationController
  def index
    task_status_id = params[:task_status_id]
    if task_status_id.blank?
      @task = Task.all
    else
      @task = Task.search_by_status_id(task_status_id)
    end
  end

  def new
     @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      flash[:notice] = t('dictionary.message.create.complete')
      redirect_to root_path
    else
      @status_selection = task_status_list
      render 'new'
    end
  end

  def show
    unless @task = Task.find_by(id: params[:id])
      flash[:notice] = t('dictionary.message.notfound')
      redirect_to root_path
    end
  end

  def update
    @task = Task.find(params[:id])
    if @task.update(task_params)
      flash[:notice] = t('dictionary.message.update.complete')
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
    flash[:notice] = t('dictionary.message.destroy.complete')
    redirect_to root_path
  end
end

private
  def task_params
    params.require(:task).permit(:title, :description, :task_status_id)
  end
