class TaskController < ApplicationController
  protect_from_forgery
  before_action :set_session_id_for_test

  def new
    @task = Task.new()
    @task.due_date = Date.today
  end

  def edit
    @task = Task.find(params[:id])
  end

  def show
    @task = Task.find(params[:id])
  end

  def create
    @task = Task.new(task_params)
    @task.user_id = session[:user_id]

    if @task.save
      redirect_to task_show_path(id: @task.id), notice: I18n.t('flash.create')
    else
      render :new
    end
  end

  def update
    @task = Task.find(task_params[:id])

    if @task.update(task_params)
      redirect_to task_edit_path(id: task_params[:id]), notice: I18n.t('flash.updated')
    else
      render :edit
    end
  end

  def destroy
    @task = Task.find(params[:id])

    if @task.present? && @task.destroy
      redirect_to task_list_path, notice: I18n.t('flash.destroy')
    else
      render :list
    end
  end

  def list
    # 検索用
    @task = Task.new()
    # 検索結果
    @tasks = Task.searchAll(session["user_id"])
  end

  def task_params
    params.require(:task).permit(
      :user_id,
      :id,
      :name,
      :description,
      :labels,
      :status,
      :due_date
    )
  end

  #ログイン実装後、削除
  def set_session_id_for_test
    session[:user_id] = "1111"
  end
end
