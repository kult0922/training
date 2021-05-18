class TasksController < ApplicationController
  before_action :set_task, only: %i[show edit update destroy]

  def index
    # raise # FOR DEBUG!! 500 error
    @tasks = Task.all
  end

  def show
    # p @task.name
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)

    if @task.save # success in submit
      flash[:success] = t('flash.create.success')
      redirect_to @task # make GET method
      # GET -> tasks/:id -> tasks/show?
    else # false in submit
      flash[:danger] = t('flash.create.danger')
      render :new # Not make GET method
    end
  end

  def edit
  end

  def update
    if @task.update(task_params) # success in submit
      flash[:success] = t('flash.update.success')
      redirect_to @task # make GET method
      # GET -> tasks/:id -> tasks/show?
    else # false in submit
      flash[:danger] = t('flash.update.danger')
      render :edit # Not make GET method
    end
  end

  def destroy
    @task.destroy
    flash[:success] = t('flash.delete.success')
    redirect_to @task # make GET method
  end

  private # only for this class

  def task_params
    params.require(:task).permit(:name, :description)
  end

  def set_task
    @task = Task.find(params[:id])
    #     # p @task.name
    #     # p "#{params[:id]}"
  end
end
