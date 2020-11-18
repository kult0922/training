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

        if inputParams.save
            redirect_to :action => 'index'
        else
            render "newtask"
        end

        
    end
end
