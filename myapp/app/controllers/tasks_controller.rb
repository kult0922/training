class TasksController < ApplicationController
  before_action :find_task, only: %i[show edit update destroy]
  before_action :find_labels, only: %i[index new create edit update]
  before_action :find_task_statuses, only: %i[index new create edit update]
  before_action :find_label_names, only: %i[index new create edit update]
  before_action :require_login
  PAGE_PER = 5

  def index
    @sort = params[:sort] if allowed_name.include?(params[:sort])
    @sort = '' if @sort.blank?
    search_form
    @tasks = Task.where(user_id: current_user.id)
                 .includes(:user)
                 .includes(:labels)
                 .search(@search_tasks.title, @search_tasks.status, @search_tasks.label_ids)
                 .order(@sort)
                 .page(params[:page])
                 .per(PAGE_PER)
  end

  def new
    @task = Task.new
  end

  def create
    @task = @current_user.tasks.new(task_params)
    if @task.save
      flash[:success] = t '.flash.success'
      redirect_to tasks_path
    else
      flash.now[:danger] = t '.flash.danger'
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @task.update(task_params)
      flash[:success] = t '.flash.success'
      redirect_to task_path(@task)
    else
      flash.now[:danger] = t '.flash.danger'
      render :edit
    end
  end

  def destroy
    @task.destroy
    flash[:success] = 'Taskは正常に削除されました'
    redirect_to tasks_path
  end

  private

  def task_params
    params.require(:task).permit(:title, :memo, :deadline, :status, :user_id, { label_ids: [] })
  end

  def allowed_name
    desc_columns = Task::SORTABLE_COLUMNS.map { |c| c + ' desc' }
    Task::SORTABLE_COLUMNS | desc_columns
  end

  def search_form
    search_title = params[:title]
    search_status = params[:status]
    search_label_ids = params[:label_ids]
    @search_tasks = TaskSearchParam.new(title: search_title, status: search_status, label_ids: search_label_ids)
    if @search_tasks.invalid?
      flash[:danger] = t '.flash.danger'
      redirect_to tasks_path
    end
  end

  def find_task
    @task = Task.find(params[:id])
  end

  def find_task_statuses
    @task_statuses = Task.statuses.map { |k, _| [Task.human_attribute_enum_val(:status, k), k] }.to_h
  end

  def find_label_names
    @label_names = Label.all.map { |label| [label.name, label.id] }.to_h
  end

  def find_labels
    @labels = Label.all
  end
end
