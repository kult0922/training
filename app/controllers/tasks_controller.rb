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
        inputParams = Task.new(params.require(:task).permit(:status, :title, :detail))

        # 成功
        if inputParams.save
            redirect_to :action => 'index'
        # 失敗
        else
            render "newtask"
        end
    end

    # タスク詳細
    def taskdetail
        param_id =  params[:id]

        @taskInfos = Task.find(param_id)
        # p @taskInfos
    end
end
