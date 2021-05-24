class TasksController < ApplicationController
  def index
    @all_tasks = Task.all
  end

  def create
    @task = Task.new(params.require(:task).permit(:name, :description))
    if @task.save
      redirect_to tasks_path, notice: 'タスクの登録に成功しました'
    else
      flash.now[:alert] = 'タスクの登録に失敗しました'
    end
  end

  def new
    @task = Task.new
    render :edit
  end
end
