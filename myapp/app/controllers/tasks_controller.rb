class TasksController < ApplicationController
PAGE_PER = 5
  def index
    sort = params[:sort] if allowed_name.include?(params[:sort])
    @tasks = Task.search(params[:title], params[:status]).order(sort).page(params[:page]).per(PAGE_PER)
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.create(task_params)
    if @task.save
      flash[:success] = 'Taskは正常に作成されました'
      redirect_to tasks_path
    else
      flash.now[:danger]= 'Taskの作成に失敗しました'
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
      flash[:success] = 'Taskは正常に更新されました'
      redirect_to task_path(@task)
    else
      flash.now[:danger]= 'Taskの更新に失敗しました'
      render :edit
    end
  end

  def destroy
    @task = Task.find(params[:id])

    @task.destroy
    flash[:success] = 'Taskは正常に削除されました'
    redirect_to tasks_path
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
