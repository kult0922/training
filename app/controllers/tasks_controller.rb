class TasksController < ApplicationController
  protect_from_forgery

  rescue_from ActiveRecord::RecordNotFound, with: :render_404

  def index
    @search_params = task_search_params
    @tasks = Task.search(params[:search])
  end

  def show
    @task = Task.find_by(id: params[:id], deleted_flag: false)
    if @task == nil
      render_404
    end
  end

  def create
    @task = Task.new
  end

  def new 
    task_params = params[:task].permit(:name, :description, :status_code, :priority_code, :expire_date)
    @task = Task.new(task_params)
  
    @task.register_user_id = 0

    if @task.save()
      flash[:success] = "Success"
      redirect_to controller: 'tasks', action: 'show', id: @task.id
    else
      flash.now[:danger] = "Error"
      render action: :create
    end
  end

  def edit
    @task = Task.find_by(id: params[:id], deleted_flag: false)
    if @task == nil
      render_404
    end
  end

  def update
    @task = Task.find(params[:task][:id])
    task_params = params[:task].permit(:name, :description, :status_code, :priority_code, :expire_date)
    @task.update(task_params)

    if @task.save()
      flash[:success] = "Success"
      redirect_to controller: 'tasks', action: 'show', id: @task.id
    else
      flash.now[:danger] = "Error"
      render action: :edit
    end
  end

  def delete
    task = Task.find_by(id: params[:id], deleted_flag: false)
    if task == nil
      render_404
    end

    task.deleted_flag = true

    if task.save()
      flash[:success] = "Success"
    else
      flash[:danger] = "Error"
    end

    redirect_to controller: 'tasks', action: 'index'
  end

  private
    def render_404(e = nil)
      render file: Rails.root.join("public/404.html"), status: 404, layout: false, content_type: 'text/html'
    end

    def task_search_params
      params.fetch(:search, {}).permit(:task_name, :status_code, :register_user_id)
    end
end
