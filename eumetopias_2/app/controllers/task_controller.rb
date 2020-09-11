class TaskController < ApplicationController
  PER = 10
  before_action :require_login
  before_action :own_task_only, only: [:show, :edit, :update, :destroy]

  def index
    @task = Task.search(current_user.id,
      params[:task_status_id], params[:label_id],
      params[:page], PER)
  end

  def new
     @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    @task.user_id = current_user.id
    if @task.save
      flash[:notice] = t('dictionary.message.create.complete')
      redirect_to root_path
    else
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
  end

  def destroy
    @task = Task.find(params[:id])
    @task.destroy
    flash[:notice] = t('dictionary.message.destroy.complete')
    redirect_to root_path
  end
end

def require_login
  unless logged_in?
    flash[:error] = t('dictionary.message.require_login')
    redirect_to login_path
  end
end

def own_task_only
  @task = Task.find(params[:id])
  unless @task.user_id == current_user.id
    flash[:error] = t('dictionary.message.cant_manage_this_task')
    redirect_to root_path
  end
end

private
  def task_params
    params.require(:task).permit(:title, :description, :task_status_id, labelid, { label_ids: [] })
  end
