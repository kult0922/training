class TasksController < ApplicationController
  def index
    @selected_status = params[:status]
    @selected_column = params[:sort]
    @selected_direction = params[:direction]
    @search_name = params[:name]
    @tasks = Task.search(@search_name, @selected_status, @selected_column, @selected_direction).page(params[:page])
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
      flash[:create] = t('flash.create')
      redirect_to root_path
    else
      flash[:create_failure] = t('flash.create_failure')
      render :new
    end
  end

  def edit
    @task = Task.find(params[:id])
  end

  def update
    @task = Task.find(params[:id])

    if @task.update(task_params)
      flash[:update] = t('flash.update')
      redirect_to root_path
    else
      flash[:update_failure] = t('flash.update_failure')
      render :edit
    end
  end

  def destroy
    @task = Task.find(params[:id])
    return unless @task.destroy

    flash[:destroy] = t('flash.destroy')
    redirect_to root_path
  end

  private

  def task_params
    params.require(:task).permit(:name, :description, :end_date, :priority, :status)
  end
end
