class TasksController < ApplicationController
  before_action :set_task, only: %i[show edit update destroy]

  def index
    @tasks = Task.all
  end

  def show
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)

    if @task.save # success in submit
      flash[:success] = 'Task was submitted'
      redirect_to @task # make GET method
      # GET -> tasks/:id -> tasks/show?
    else # false in submit
      flash[:danger] = 'Task was NOT submitted'
      render :new # Not make GET method
    end
  end

  def edit
  end

  def update
    if @task.update(task_params) # success in submit
      flash[:success] = 'Task was edited'
      redirect_to @task # make GET method
      # GET -> tasks/:id -> tasks/show?
    else # false in submit
      flash[:danger] = 'Task was NOT edited'
      render :edit # Not make GET method
    end
  end

  def destroy
    @task.destroy

    flash[:success] = 'Task was deleted'
    redirect_to @task # make GET method
  end
end

private # only for this class

def task_params
  params.require(:task).permit(:name, :description)
end

def set_task
  @task = Task.find(params[:id])
end
