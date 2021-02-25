# frozen_string_literal: true

# タスクコントローラー
class TasksController < ApplicationController
  attr_reader :task, :user

  before_action :check_login_user
  before_action :set_labels

  # TODO: 将来的にはSPAにし、タスク管理を1画面で完結させたい
  # ■画面表示系
  #
  # 一覧画面
  # GET /tasks
  def index
    @search_params = params
    @label_ids_json = @search_params[:label_ids].to_json
    @order = @search_params[:order]
    @status = @search_params[:status].presence || 'all'
    @tasks = Task.find_tasks(current_user.id, @search_params, @order)
  end

  # 詳細画面
  # GET /tasks/[:タスクテーブルID]
  def show
    @task = Task.find_by(id: params[:id], user_id: current_user.id)
    return if check_existence_task(@task)
  end

  # 作成画面
  # GET /tasks/new
  def new
    @task = Task.new
  end

  # 編集画面
  # GET /tasks/[:タスクテーブルID]/edit
  def edit
    @task = Task.find_by(id: params[:id], user_id: current_user.id)
    return if check_existence_task(@task)
  end

  # ■画面更新系
  #
  # タスクを作成する
  # POST /tasks
  def create
    @task = Task.new(task_params)
    @task.user_id = current_user.id
    if @task.save
      flash[:notice] = I18n.t('flash.success.create',
                              name: I18n.t('tasks.header.name'),
                              value: @task.name)
      unless regist_task_label(@task, params[:label_ids])
        flash[:alert] = I18n.t('tasks.flash.error.create',
                               table: I18n.t('activerecord.models.task_label_relation'))
      end
      redirect_to action: :new
    else
      render :new
    end
  end

  # タスクを更新する
  # POST /tasks/[:タスクテーブルID]
  def update
    @task = Task.find_by(id: params[:id], user_id: current_user.id)
    if @task.update(task_params)
      flash[:notice] = I18n.t('flash.success.update',
                              name: I18n.t('tasks.header.name'),
                              value: @task.name)
      unless regist_task_label(@task, params[:label_ids])
        flash[:alert] = I18n.t('tasks.flash.error.create',
                               table: I18n.t('activerecord.models.task_label_relation'))
      end
      redirect_to action: :edit
    else
      render :edit
    end
  end

  # タスクを削除する
  # POST /tasks/[:タスクテーブルID]
  def destroy
    @task = Task.find_by(id: params[:id], user_id: current_user.id)
    if @task.destroy
      flash[:notice] = I18n.t('flash.success.delete',
                              name: I18n.t('tasks.header.name'),
                              value: @task.name)
      redirect_to tasks_url
    else
      render tasks_url
    end
  end

  private

  def task_params
    params.require(:task).permit(:id, :name, :details, :deadline, :status, :priority, label_ids: [])
  end

  def check_existence_task(task)
    render_404 if task.blank?
  end

  def regist_task_label(task, label_ids)
    success_flg = true
    task.task_label_relations.delete_all
    return success_flg if label_ids.blank?
    label_ids.each do |label_id|
      task_label_relations = task.task_label_relations.create(label_id: label_id)
      success_flg = false unless task_label_relations.save
    end
    success_flg
  end

  def set_labels
    @labels = Label.where(user_id: current_user.id)
  end
end
