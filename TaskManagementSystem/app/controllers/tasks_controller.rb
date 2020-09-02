# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :set_task, only: %i[show edit update destroy]

  def index
    @tasks = Task.all.order(created_at: :desc).page(params[:page]).per(10)
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      redirect_to task_path(@task), success: '新しいタスクを作成しました'
    else
      flash.now[:danger] = 'タスクの作成に失敗しました'
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @task.update(task_params)
      redirect_to task_path(@task), success: 'タスクの更新に成功しました'
    else
      flash.now[:danger] = 'タスクの更新に失敗しました'
      render :edit
    end
  end

  def destroy
    if @task.destroy
      redirect_to root_path, success: 'タスクを削除しました'
    else
      redirect_to root_path, danger: 'タスクを削除できませんでした'
    end
  end

  def search
    # 終了期限のソートorステータスorタスク名の検索
    @tasks = Task.deadline_sort(params[:deadline_keyword]).search_status(params[:status_keyword]).search_title(params[:title_keyword]).page(params[:page]).per(10)
  end

  private

  def set_task
    begin
      @task = Task.find(params[:id])
    rescue => e
      redirect_to root_path, danger: '存在しないタスクです'
    end
  end

  def task_params
    params.require(:task).permit(:user_id, :title, :description, :priority, :status, :deadline)
  end
end
