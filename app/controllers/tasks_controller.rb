# frozen_string_literal: true

class TasksController < ApplicationController
  # タスク一覧画面
  def index
    # ソート順のパラメータを取得
    @sortno = params['sortno']
    # デフォルトのソート順は作成日順
    sortOrder = "created_at DESC";

    # 終了期限順だった場合
    if @sortno == "2"
      sortOrder = "end_date DESC";
    end

    # タスクテーブルからデータを取り出す
    @tasks = Task.all.order(sortOrder)
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
    statusParam =  params[:task][:status].to_i
    titleParam =  params[:task][:title]
    detailParam =  params[:task][:detail]
    endDateParam =  params[:task][:end_date]

    @task = Task.new(status: statusParam, title: titleParam, detail: detailParam, end_date: endDateParam)

    # 登録成功
    if @task.save
      flash[:success] = I18n.t("msg.success_registration")
      redirect_to action: "index"
    # 失敗
    else
      flash.now[:warning] = I18n.t("msg.failed_registration")
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

    @tasksList = Task.statuses

    # パラメータのIDを元にタスクテーブルを検索
    @task = Task.find(param_id)
  end

  # タスク更新処理
  def taskupdateprocess
    # Getパラメータの取得
    param_id = params[:task][:hid]
    param_status = params[:task][:status].to_i
    param_title = params[:task][:title]
    param_detail = params[:task][:detail]
    param_endDate = params[:task][:end_date]

    # タスクテーブルを検索
    updateTask = Task.find(param_id)
    updateTask.status = param_status
    updateTask.title = param_title
    updateTask.detail = param_detail
    updateTask.end_date = param_endDate

    # 更新成功
    if updateTask.save

      flash[:success] = I18n.t("msg.success_update")
      redirect_to action: "index"
    # 失敗
    else
      flash.now[:warning] = I18n.t("msg.failed_update")
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
      flash[:success] = I18n.t("msg.success_delete")
      redirect_to action: "index"
    # 失敗
    else
      flash.now[:warning] = I18n.t("msg.failed_delete")
      render "taskdetail"
    end
  end

  def params_int(model_params)
    model_params.each do |key,value|
      if integer_string?(value)
        model_params[key]=value.to_i
      end
    end
  end
end
