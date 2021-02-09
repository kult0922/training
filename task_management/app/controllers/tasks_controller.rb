# frozen_string_literal: true

# タスクコントローラー
class TasksController < ApplicationController
  attr_reader :task, :user

  before_action :check_login_user

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
      flash[:notice] = '登録が完了しました。'
      redirect_to action: :new
    else
      flash.now[:alert] = '登録に失敗しました。'
      render :new
    end
  end

  # タスクを更新する
  # POST /tasks/[:タスクテーブルID]
  def update
    @task = Task.find_by(id: params[:id], user_id: current_user.id)
    if @task.update(task_params)
      flash[:notice] = '更新が完了しました。'
      redirect_to action: :edit
    else
      flash.now[:alert] = '更新に失敗しました。'
      render :edit
    end
  end

  # タスクを削除する
  # POST /tasks/[:タスクテーブルID]
  def destroy
    @task = Task.find_by(id: params[:id], user_id: current_user.id)
    if @task.destroy
      flash[:notice] = '削除しました。'
      redirect_to tasks_url
    else
      flash.now[:alert] = '削除に失敗しました。'
      render tasks_url
    end
  end

  private

  def task_params
    # TODO: ステップ20でラベル選択、複数登録可能とする
    params.require(:task).permit(:name, :details, :deadline, :status, :priority, label_ids: [])
  end

  def check_existence_task(task)
    render_404 if task.blank?
  end

  def check_login_user
    return if logged_in?
    redirect_to controller: :sessions, action: :index
  end
end
