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
    @task = Task.find(params[:id])
  end

  def update
    @task = Task.find(params[:id]) # get want to edit task id

    if @task.update(task_params) # success in submit
      flash[:success] = "Task was edited"
      redirect_to @task # make GET method
      # GET -> tasks/:id -> tasks/show?
    else # false in submit
      flash[:danger] = "Task was NOT edited"
      render :edit # Not make GET method
    end
  end

  def destroy
    @task = Task.find(params[:id]) # get want to delete task id
    @task.destroy

    flash[:success] = "Task was deleted"
    redirect_to @task # make GET method
  end

end

private # only for this class
def task_params
  params.require(:task).permit(:name, :description)
end
