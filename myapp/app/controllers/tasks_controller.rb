class TasksController < ApplicationController
  def index
    sort = params[:sort] if allowed_name.include?(params[:sort])
    @tasks = Task.all.search(params[:title], params[:status]).order(sort).page(params[:page]).per(5)
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.create(task_params)
    if @task.save
      redirect_to tasks_path, notice: 'Taskは正常に作成されました'
    else
      render :new
    end
  end

  def show
    @task = Task.find(params[:id])
  end

  def edit
    @task = Task.find(params[:id])
  end

  def update
    @task = Task.find(params[:id])

    if @task.update(task_params)
      redirect_to task_path(@task), notice: 'Taskは正常に更新されました'
    else
      render :edit
    end
  end

  def destroy
    @task = Task.find(params[:id])

    @task.destroy
    redirect_to tasks_path, notice: 'Taskは正常に削除されました'
  end

  private
    def task_params
      params.require(:task).permit(:title, :memo, :deadline, :status)
    end

   def allowed_name
     desc_column = Task.column_names.map { |c| c + ' desc' }
     allowed_name = Task.column_names | (desc_column)
     return allowed_name
   end
end
