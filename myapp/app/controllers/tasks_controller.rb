class TasksController < ApplicationController
  before_action :set_users, only: [:new, :edit]
  before_action :set_select_status, only: [:index, :new, :edit]
  PAGE_PER = 5

  def index
    @sort = params[:sort] if allowed_name.include?(params[:sort])
    @sort = '' if @sort.blank?
    search_form
    @tasks = Task.includes(:user).search(@search_tasks.title, @search_tasks.status).order(@sort).page(params[:page]).per(PAGE_PER)
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
    params.require(:task).permit(:title, :memo, :deadline, :status, :user_id)
  end

  def allowed_name
    desc_columns = Task::SORTABLE_COLUMNS.map { |c| c + ' desc' }
    Task::SORTABLE_COLUMNS | desc_columns
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

  def set_select_status
    @status = Task.statuses.map {|k, _| [Task.human_attribute_enum_val(:status, k), k] }.to_h
  end

  def set_users
    @users = User.all
  end
end
