# frozen_string_literal: true

# タスクコントローラー
class TasksController < ApplicationController
  attr_reader :task, :user

  before_action :check_login_user
  before_action :set_login_user, only: %i[index create]

  # TODO: 将来的にはSPAにし、タスク管理を1画面で完結させたい
  # ■画面表示系
  #
  # 一覧画面
  # GET /tasks
  def index
    @order = params[:order]
    @tasks = Task.where(user_id: current_user.id)
                 .get_status(params[:status])
                 .search_word(params[:search_word])
                 .sort_key(params[:sort], @order)
                 .page(params[:page])
  end

  # 詳細画面
  # GET /tasks/[:タスクテーブルID]
  def show
    @task = Task.find_by(id: params[:id], user_id: current_user.id)
    check_existence_task(@task)
  end

  # 作成画面
  # GET /tasks/new
  def new
    @task = Task.new
  end

  # 編集画面
  # GET /tasks/[:タスクテーブルID]/edit
  def edit
    @task = Task.find_by(id: params[:id], user_id: current_user.id)
    check_existence_task(@task)
  end

  # ■画面更新系
  #
  # タスクを作成する
  # POST /tasks
  def create
    @task = Task.new(task_params)
    @task.user_id = current_user.id
    if @task.save
      flash[:notice] = I18n.t('flash.success.create',
                              name: I18n.t('tasks.header.name'),
                              value: @task.name)
      redirect_to action: :new
    else
      render :new
    end
  end

  # タスクを更新する
  # POST /tasks/[:タスクテーブルID]
  def update
    @task = Task.find_by(id: params[:id], user_id: current_user.id)
    if @task.update(task_params)
      flash[:notice] = I18n.t('flash.success.update',
                              name: I18n.t('tasks.header.name'),
                              value: @task.name)
      redirect_to action: :edit
    else
      render :edit
    end
  end

  # タスクを削除する
  # POST /tasks/[:タスクテーブルID]
  def destroy
    @task = Task.find_by(id: params[:id], user_id: current_user.id)
    if @task.destroy
      flash[:notice] = I18n.t('flash.success.delete',
                              name: I18n.t('tasks.header.name'),
                              value: @task.name)
      redirect_to tasks_url
    else
      render tasks_url
    end
  end

  private

  def task_params
    # TODO: ステップ20でラベル選択、複数登録可能とする
    params.require(:task).permit(:id, :name, :details, :deadline, :status, :priority, label_ids: [])
  end

  def check_existence_task(task)
    render_404 if task.blank?
  end

  def set_login_user
    @login_user = current_user
  end

  def check_login_user
    return if logged_in?
    redirect_to controller: :sessions, action: :index
  end
end
