class TasksController < ApplicationController

  before_action :find_task, only: [:edit, :update, :show, :destroy]

  def index
    @tasks = Task.sort_tasks(request_sort_params)
    @sort = display_sort
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      flash[:success] = t('tasks.flash.success.create')
      redirect_to root_path
    else
      render :new
    end
  rescue => e
    Rails.logger.error(e)
    Rails.logger.error(e.backtrace.join("\n"))
  end

  def update
    if @task.update(task_params)

      flash[:success] = t('tasks.flash.success.update')
      redirect_to task_path(@task)
    else
      render :edit
    end
  end

  def destroy
    @task.delete

    flash[:success] = t('tasks.flash.success.destroy')
    redirect_to root_path
  end

  private

  def task_params
    params.require(:task).permit(:title, :description, :due_date)
  end

  def find_task
    @task = Task.find_by(id: params[:id])
  end

  def request_sort_params
    { params[:sort_key]&.to_sym => params[:sort_val] } if params[:sort_key].present? && params[:sort_val].present?
  end

  def display_sort
    default = { created_at: :desc, due_date: :desc }
    if request_sort_params
      default.merge!(request_sort_params.map {|k,v| [k.to_sym, (v.to_sym.eql?(:desc) ? :asc : :desc)] }.to_h)
    else
      default
    end
  end
end
