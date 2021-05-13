class TasksController < ApplicationController
  def index
    @tasks = Task.all
  end

  def show
    @task = Task.find(params[:id])
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)

    if @task.save # success in submit
      flash[:success] = "Task was submitted"
      redirect_to @task # make GET method
      # GET -> tasks/:id -> tasks/show?
    else # false in submit
      flash[:danger] = "Task was NOT submitted"
      render :new # Not make GET method
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end
end

private # only for this class
def task_params
  params.require(:task).permit(:name)
  params.require(:task).permit(:description)
end
