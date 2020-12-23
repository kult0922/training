class TaskController < ApplicationController

  # TODO:将来的にはSPAにし、タスク管理を1画面で完結させたい
  # ■画面表示系
  #
  # 一覧画面
  # GET /task
  # TODO:ユーザIDを画面からの連携パラメータに追加する。現状、テスト用のユーザIDを設定している
  # TODO:ログイン画面を作ったらGETからPOSTに変更する
  def index
    test_user_id = "yokuno"
    @tasks = TaskManager.getUserTasks(test_user_id)
  end

  # 詳細画面
  # GET /task/[:タスクテーブルID]
  def details
    test_user_id = "yokuno"
    @tasks = TaskManager.find(params[:taskId])
  end

  # 作成画面
  # GET /task/new
  def new
    @tasks = TaskManager.new
  end

  # 編集画面
  # GET /task/edit
  def edit
    @tasks = TaskManager.all
  end

  # ■画面編集系

end
