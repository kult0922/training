# frozen_string_literal: true

class TasksController < ApplicationController
  attr_reader :task, :login_user

  before_action :check_login_user
  before_action :set_login_user, only: %i[index create]

  # TODO: 将来的にはSPAにし、タスク管理を1画面で完結させたい
  # ■画面表示系
  #
  # 一覧画面
  # GET /tasks
  def index
    # ソートキーを設定
    sort = params[:sort]
    order = if sort.nil?
              'creation_date DESC'
            else
              sort + ' DESC'
            end
    search_btn = params[:search_btn]
    # 検索ボタンを押下した場合
    if t('.search') == search_btn
      search_word = params[:search_word]
      status      = params[:status]
      status = Task.statuses.values if status == 'all'
      @tasks = Task.where(user_id: @login_user.id)
                     .where(status: status)
                     .where('name like ?', '%' + search_word + '%')
                     .order(order).page(params[:page])
    else
      @tasks = Task.where(user_id: @login_user.id).order(order).page(params[:page])
    end
  end

  # 詳細画面
  # GET /tasks/[:タスクテーブルID]
  def show
    @task = Task.find(params[:id])
  end

  # 作成画面
  # GET /tasks/new
  def new
    @task = Task.new
  end

  # 編集画面
  # GET /tasks/[:タスクテーブルID]/edit
  def edit
    @task = Task.find(params[:id])
  end

  # ■画面更新系
  #
  # タスクを作成する
  # POST /tasks
  def create
    @task = Task.new(task_params)
    @task.user_id = @login_user.id
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
    @task = Task.find(params[:id])
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
    Task.find(params[:id]).destroy
    flash[:notice] = '削除しました。'
    redirect_to tasks_url
  end

  private

  def task_params
    # TODO: ステップ20でラベル選択、複数登録可能とする
    params.require(:task).permit(:name,
                                 :details,
                                 :deadline,
                                 :status,
                                 :priority,
                                 label_ids: [])
  end

  def check_login_user
    return if logged_in?
    redirect_to controller: :sessions, action: :index
  end

  def set_login_user
    @login_user = current_user
  end
end
