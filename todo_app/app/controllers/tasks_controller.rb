class TasksController < ApplicationController
  def index
    @tasks = Task.all
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    if @task.save!
      flash[:success] = "タスクを登録しました"
      redirect_to root_path
    end
  end

  def show
    @task = Task.find_by(id: params[:id])
  end

  def edit
    @task = Task.find_by(id: params[:id])
  end

  def update
    @task = Task.find_by(id: params[:id])
    if @task.update!(task_params)
      flash[:success] = "タスクを編集完了しました"
      redirect_to root_path
    end
  end

  def destroy
    @task = Task.find_by(id: params[:id])
    @task.delete

    flash[:success] = "タスクを削除しました"
    redirect_to root_path
  end

  private def task_params
    params.require(:task).permit(:title, :description)
  end
end
