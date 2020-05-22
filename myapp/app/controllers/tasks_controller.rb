class TasksController < ApplicationController
  PAGE_PER = 5

  def index
    sort = params[:sort] if allowed_name.include?(params[:sort])
    search_form
    @tasks = Task.search(@search_tasks.title, @search_tasks.status).order(sort).page(params[:page]).per(PAGE_PER)
    sort_notice(sort) if sort.present?
  end

  def sort_notice(sort)
    if sort.include?('desc')
      default_column = sort.chomp(' desc')
      flash[:success] = t ".flash.#{default_column}_sort_desc"
    else
      flash[:success] = t ".flash.#{sort}_sort_asc"
    end
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.create(task_params)
    if @task.save
      flash[:success] = t '.flash.success'
      redirect_to tasks_path
    else
      flash.now[:danger] = t '.flash.danger'
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
      flash[:success] = t '.flash.success'
      redirect_to task_path(@task)
    else
      flash.now[:danger] = t '.flash.danger'
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
    Task.column_names | desc_column
  end

  def search_form
    search_title = params[:title]
    search_status = params[:status]
    @search_tasks = TaskSearchParam.new(title: search_title, status: search_status)
    if @search_tasks.invalid?
      flash[:danger] = t '.flash.danger'
      redirect_to tasks_path
    end
  end
end
