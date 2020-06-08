class TasksController < ApplicationController
  helper_method :sort_column, :sort_direction
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  before_action :logged_in_user

  def index
    @search = { name: params[:name], status: params[:status] }
    @tasks = Task.eager_load(:user)
                 .where(user: @current_user)
                 .search(@search)
                 .rearrange(sort_column, sort_direction)
                 .page(params[:page]).per(PER)
  end

  def new
    @task = Task.new
  end

  def create
    @task = @current_user.tasks.new(task_params)
    trunc_sec_due_at

    if @task.save
      redirect_to tasks_path, flash: { success: I18n.t('flash.model.succeeded', target: I18n.t(@task.model_name.human), action: '作成') }
    else
      flash.now[:danger] = I18n.t('flash.model.failed', target: I18n.t(@task.model_name.human), action: '作成')
      render :new
    end
  end

  def show; end

  def edit; end

  def update
    trunc_sec_due_at

    if @task.update(task_params)
      redirect_to task_path(@task), flash: { success: I18n.t('flash.model.succeeded', target: I18n.t(@task.model_name.human), action: '更新') }
    else
      flash.now[:danger] = I18n.t('flash.model.failed', target: I18n.t(@task.model_name.human), action: '更新')
      render :edit
    end
  end

  def destroy
    if @task.destroy
      redirect_to tasks_path, flash: { success: I18n.t('flash.model.succeeded', target: I18n.t(@task.model_name.human), action: '削除') }
    else
      flash.now[:danger] = I18n.t('flash.model.failed', target: I18n.t(@task.model_name.human), action: '削除')
      render :show
    end
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:name, :description, :due_at, :have_a_due, :status)
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
end
