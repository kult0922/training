# frozen_string_literal: true

# タスクコントローラー
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
    if search_btn == I18n.t('tasks.button.type.search')
      search_word = params[:search_word]
      status      = params[:status]
      status      = Task.statuses.values if status == 'all'
      @tasks = Task.where(user_id: @login_user.id)
                   .where(status: status)
                   .where('name like ?', '%' + search_word + '%')
                   .order(order).page(params[:page])
    else
      @tasks = Task.where(user_id: @login_user.id)
                   .order(order)
                   .page(params[:page])
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
    @task = Task.find(params[:id])
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
    @task = Task.find(params[:id])
    @task.destroy
    flash[:notice] = I18n.t('flash.success.delete',
                            name: I18n.t('tasks.header.name'),
                            value: @task.name)
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

  def set_login_user
    @login_user = current_user
  end

  def check_login_user
    redirect_to login_path unless logged_in?
  end
end
