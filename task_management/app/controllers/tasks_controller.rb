class TasksController < ApplicationController
  attr_reader :task
  # TODO: ユーザIDを画面からの連携パラメータに追加する。現状、テスト用のユーザIDを設定している。ステップ17で見直す。
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
    # step17で見直す。
    # 将来的にログインユーザーしか見れないように対策が必要
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

  # ■画面編集系
  #
  # タスクを作成する
  # POST /tasks
  def create
    @task = Task.new(task_params)

    if @task.save
      flash[:notice] = '登録が完了しました。'
      redirect_to action: :new
    else
      flash.now[:notice] = '登録に失敗しました。'
      render :new
    end
  end

  # タスクを更新する
  # POST /tasks/[:タスクテーブルID]
  def update
    @task = Task.find(params[:id])

    # TODO : ユーザIDを更新対象から除外している。書き方はステップ17で見直す。
    status = Task.statuses[params[:task][:status]]
    priority = Task.priorities[params[:task][:priority]]

    if @task.update(name: params[:name], details: params[:details], deadline: params[:deadline],
                    status: status, priority: priority)
      flash[:notice] = '更新が完了しました。'
      redirect_to action: :edit
    else
      render :edit
    end
  end

  # タスクを削除する
  # POST /tasks/[:タスクテーブルID]
  def destroy

  end

  def task_params
    # TODO: ステップ20でラベルを選択し、複数登録可能とする
    params.require(:task).permit(:user_id, :name, :details, :deadline, :status, :priority, label_ids: [])
  end
end
