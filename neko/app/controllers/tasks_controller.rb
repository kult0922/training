class TasksController < ApplicationController
  helper_method :sort_column, :sort_direction
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  before_action :set_labels, only: [:index, :list, :new, :create, :edit, :update]
  before_action :logged_in_user

  def index(user = current_user)
    @search = { name: params[:name], status: params[:status], label_ids: params[:label_ids] }
    @tasks = Task.eager_load(:user)
                 .eager_load(:labels)
                 .where(user: user)
                 .search(@search)
                 .rearrange(sort_column, sort_direction)
                 .page(params[:page])
  end

  def list
    @user = User.find(params[:id])
    render action: index(@user), template: 'tasks/index'
  end

  def new
    @task = Task.new
  end

  def create
    @task = @current_user.tasks.new(task_params)
    trunc_sec_due_at

    if @task.save
      flash[:success] = I18n.t('flash.model.succeeded', target: @task.model_name.human, action: I18n.t(action_name))
      redirect_to tasks_path
    else
      flash.now[:danger] = I18n.t('flash.model.failed', target: @task.model_name.human, action: I18n.t(action_name))
      render :new
    end
  end

  def show; end

  def edit; end

  def update
    trunc_sec_due_at

    if @task.update(task_params)
      flash[:success] = I18n.t('flash.model.succeeded', target: @task.model_name.human, action: I18n.t(action_name))
      redirect_to task_path(@task)
    else
      flash.now[:danger] = I18n.t('flash.model.failed', target: @task.model_name.human, action: I18n.t(action_name))
      render :edit
    end
  end

  def destroy
    if @task.destroy
      flash[:success] = I18n.t('flash.model.succeeded', target: @task.model_name.human, action: I18n.t(action_name))
      redirect_to tasks_path
    else
      flash.now[:danger] = I18n.t('flash.model.failed', target: @task.model_name.human, action: I18n.t(action_name))
      render :show
    end
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:name, :description, :due_at, :have_a_due, :status, { label_ids: [] })
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'desc'
  end

  def sort_column
    Task.column_names.include?(params[:sort]) ? params[:sort] : 'created_at'
  end

  def trunc_sec_due_at
    @task.due_at = Time.zone.at(Time.current.to_i / 60 * 60) if @task.due_at.nil?
  end

  def set_labels
    @labels = Label.all
  end
end
