class TasksController < ApplicationController
  # TODO: ユーザIDを画面からの連携パラメータに追加する。現状、テスト用のユーザIDを設定している
  TEST_USER_ID = 'yokuno'

  # TODO: 将来的にはSPAにし、タスク管理を1画面で完結させたい
  # ■画面表示系
  #
  # 一覧画面
  # GET /tasks
  def index
    user_id = User.select(:id).where(login_id: TEST_USER_ID)
    @tasks = Task.where(user_id: user_id)
  end

  # 詳細画面
  # GET /tasks/[:タスクテーブルID]
  def show
    # TODO: タスクテーブルIDのみ指定の場合、ブラウザからの直接アクセスで他ユーザーのタスクが閲覧される可能性がある。
    # 将来的にログインユーザーしか見れないように対策が必要
    @task = Task.find(params[:id])
  end

  # 作成画面
  # GET /tasks/new
  def new

  end

  # 編集画面
  # GET /tasks/edit
  def edit

  end

  # ■画面編集系
  #
  # タスクを作成する
  # POST /tasks
  def create

  end

  # タスクを更新する
  # POST /tasks/:id
  def update

  end

  # タスクを削除する
  # POST /tasks/:id
  def destroy

  end

end
