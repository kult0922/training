# frozen_string_literal: true

class TasksController < ApplicationController
  # タスク一覧画面
  def index
    # タスクテーブルからデータを取り出す
    @tasks = Task.all.order(created_at: :desc)
  end

  # タスク登録画面
  def newtask
    # タスクインスタンスの生成
    @task = Task.new

    # Viewの呼び出し
    render "newtask"
  end

  # タスク登録処理
  def createtask
    insertTask = Task.new(params.require(:task).permit(:status, :title, :detail))

    # 登録成功
    if insertTask.save
      flash[:success] = "登録に成功しました！"
      redirect_to action: "index"
    # 失敗
    else
      flash.now[:warning] = "登録に失敗しました・・・"
      render "newtask"
    end
  end

  # タスク詳細
  def taskdetail
    # Getパラメータの取得
    param_id = params[:id]

    # パラメータのIDを元にタスクテーブルを検索
    @taskInfos = Task.find(param_id)
  end

  # タスク更新
  def taskupdate
    # Getパラメータの取得
    param_id = params[:id]

    # パラメータのIDを元にタスクテーブルを検索
    @task = Task.find(param_id)
  end

  # タスク更新処理
  def taskupdateprocess
    # Getパラメータの取得
    param_id = params[:task][:hid]
    param_status = params[:task][:status]
    param_title = params[:task][:title]
    param_detail = params[:task][:detail]

    # タスクテーブルを検索
    updateTask = Task.find(param_id)
    updateTask.status = param_status
    updateTask.title = param_title
    updateTask.detail = param_detail

    # 更新成功
    if updateTask.save

      flash[:success] = "更新に成功しました！"
      redirect_to action: "index"
    # 失敗
    else
      flash.now[:warning] = "更新に失敗しました・・・"
      render "taskupdate"
    end
  end

  def taskdelete
    # Getパラメータの取得
    param_id = params[:id]

    # 削除実行
    delTask = Task.destroy(param_id)

    # 削除成功
    if delTask
      flash[:success] = "削除に成功しました！"
      redirect_to action: "index"
    # 失敗
    else
      flash.now[:warning] = "削除に失敗しました・・・"
      render "taskdetail"
    end
    
  end
  
end
