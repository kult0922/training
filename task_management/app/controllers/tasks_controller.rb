# frozen_string_literal: true

# タスクコントローラー
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
    user_id = User.select(:id).find_by(login_id: TEST_USER_ID)

    # ソートキーを設定
    sort_key = params[:sort]
    @order = params[:order]
    sort = if sort_key.blank? || @order.blank?
             'creation_date' + ' ' + 'DESC'
           else
             sort_key + ' ' + @order
           end

    # 検索ボタンを押下した場合
    search_btn = params[:search_btn]
    if t('.search') == search_btn
      search_word = params[:search_word]
      status = params[:status]
      status = Task.statuses.values if status == 'all'
      @tasks = Task.where(user_id: user_id)
                   .where(status: status)
                   .where('name like ?', '%' + search_word + '%')
                   .order(sort)
    else
      @tasks = Task.where(user_id: user_id).order(sort)
    end
  end

  # 詳細画面
  # GET /tasks/[:タスクテーブルID]
  def show
    # TODO: タスクテーブルIDのみ指定の場合、ブラウザからの直接アクセスで他ユーザーのタスクが閲覧される可能性がある。
    # ログインユーザーしか見れないように対策が必要。ステップ17で見直す。
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

    # TODO : ユーザIDは更新対象外とすべき。書き方はステップ17で見直す。
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

  def task_params
    # TODO: ステップ20でラベル選択、複数登録可能とする
    params.require(:task)
          .permit(:user_id,
                  :name,
                  :details,
                  :deadline,
                  :status,
                  :priority,
                  label_ids: [])
  end
end
