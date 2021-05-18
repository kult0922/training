class TasksController < ApplicationController
    before_action :set_task, only: [:show, :edit, :update, :destroy]

    def index
        @tasks = Task.all
    end

    def new
        @task = Task.new
    end

    def create
        @task = Task.new(task_params)
        if @task.save
            redirect_to @task, notice: 'タスクの作成が完了しました'
        else
            flash.now[:alert] = 'タスクの作成に失敗しました'
            render :new
        end
    end

    def update
        if @task.update(task_params)
            redirect_to @task, notice: 'タスクの削除が完了しました'
        else
            flash.now[:alert] = 'タスクの更新に失敗しました'
            render :edit
        end
    end

    def destroy
        if @task.destroy
            redirect_to root_path, notice: 'タスクの削除が完了しました'
        else
            redirect_to root_path, alert: 'タスクの削除に失敗しました'
        end
    end

    private

    def set_task
        @task = Task.find(params[:id])
    end

    def task_params
        params.require(:task).permit(:title, :description)
    end
end
