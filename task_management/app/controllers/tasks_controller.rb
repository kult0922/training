# frozen_string_literal: true

# タスクコントローラー
class TasksController < ApplicationController
  attr_reader :task, :login_user, :task_label_relations

  before_action :check_login_user
  before_action :set_login_user
  before_action :set_labels

  # TODO: 将来的にはSPAにし、タスク管理を1画面で完結させたい
  # ■画面表示系
  #
  # 一覧画面
  # GET /tasks
  def index
    @search_params = params
    @label_ids_json = @search_params[:label_ids].to_json.html_safe
    @status = @search_params[:status]
    @status = 'all' if @status.blank?
    @tasks = find_tasks(@search_params)
  end

  # 詳細画面
  # GET /tasks/[:タスクテーブルID]
  def show
    @task = Task.find(params[:id])
  end

  # 作成画面
  # GET /tasks/new
  def new
    @task = Task.new
    @task_label_relations = TaskLabelRelation.where(task_id: @task.id)
  end

  # 編集画面
  # GET /tasks/[:タスクテーブルID]/edit
  def edit
    @task = Task.find(params[:id])
    @task_label_relations = TaskLabelRelation.where(task_id: @task.id)
  end

  # ■画面更新系
  #
  # タスクを作成する
  # POST /tasks
  def create
    @task = Task.new(task_params)
    @task.user_id = @login_user.id
    @task_label_relations = TaskLabelRelation.where(task_id: @task.id)
    if @task.save
      flash[:notice] = I18n.t('flash.success.create',
                              name: I18n.t('tasks.header.name'),
                              value: @task.name)
      unless regist_task_label(@task.id, params[:label_ids])
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
    @task = Task.find(params[:id])
    @task_label_relations = TaskLabelRelation.where(task_id: @task.id)
    if @task.update(task_params)
      flash[:notice] = I18n.t('flash.success.update',
                              name: I18n.t('tasks.header.name'),
                              value: @task.name)
      unless regist_task_label(@task.id, params[:label_ids])
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
    @task = Task.find(params[:id])
    @task.destroy
    flash[:notice] = I18n.t('flash.success.delete',
                            name: I18n.t('tasks.header.name'),
                            value: @task.name)
    redirect_to tasks_url
  end

  private

  def task_params
    params.require(:task).permit(:name,
                                 :details,
                                 :deadline,
                                 :status,
                                 :priority)
  end

  def find_tasks(params)
    search_btn = params[:search_btn]
    if search_btn == I18n.t('tasks.button.type.search')
      search_tasks(@login_user.id, params)
    else
      select_tasks(@login_user.id, params)
    end
  end

  def search_tasks(user_id, params)
    status = create_status(params[:status])
    search_word = params[:search_word]
    sort_key = create_sort_key(params[:sort])
    label_ids = params[:label_ids]

    # ラベルが選択されていない場合
    if label_ids.blank?
      task_ids = TaskLabelRelation.joins(:label)
                                  .select('task_label_relations.task_id')
      tasks = select_tasks_unlabeled(user_id,
                                     task_ids,
                                     status,
                                     search_word,
                                     sort_key)
    else
      task_id_ary = find_task_id(label_ids)
      tasks = select_tasks_with_label(user_id,
                                      task_id_ary,
                                      status,
                                      search_word,
                                      sort_key)
    end
    tasks
  end

  def select_tasks_unlabeled(user_id,
                             task_ids,
                             status,
                             search_word,
                             sort_key)

    Task.where(user_id: user_id)
        .where.not(id: task_ids)
        .where(status: status)
        .where('name like ?', '%' + search_word + '%')
        .includes(:task_label_relations, :labels)
        .order(sort_key)
        .page(params[:page])
  end

  def select_tasks_with_label(user_id,
                              task_ids,
                              status,
                              search_word,
                              sort_key)

    Task.where(user_id: user_id)
        .where(id: task_ids)
        .where(status: status)
        .where('name like ?', '%' + search_word + '%')
        .includes(:task_label_relations, :labels)
        .order(sort_key)
        .page(params[:page])
  end

  def find_task_id(label_ids)
    task_id_ary = []
    @task_label_relations = TaskLabelRelation.where(label_id: label_ids)
    @task_label_relations.each do |task_label|
      task_id_ary.push task_label.task_id if task_label.task_id.present?
    end
    task_id_ary
  end

  def select_tasks(user_id, params)
    sort_key = create_sort_key(params[:sort])
    Task.where(user_id: user_id)
        .includes(:task_label_relations, :labels)
        .order(sort_key)
        .page(params[:page])
  end

  def create_status(statuses)
    if statuses == 'all' || statuses.nil?
      Task.statuses.values
    else
      statuses
    end
  end

  def create_sort_key(key)
    order    = ' DESC'
    sort_key = if key.nil?
                 'creation_date'
               else
                 key
               end
    sort_key + order
  end

  def regist_task_label(task_id, label_ids)
    success_flg = true
    TaskLabelRelation.where(task_id: task_id).delete_all
    if label_ids.present?
      label_ids.each do |label_id|
        next if label_id.blank?
        @task_label_relations = TaskLabelRelation.create(
          task_id: task_id,
          label_id: label_id
        )
        success_flg = false unless @task_label_relations.save
      end
    end
    success_flg
  end

  def set_login_user
    @login_user = current_user
  end

  def check_login_user
    redirect_to login_path unless logged_in?
  end

  def set_labels
    @labels = Label.where(user_id: @login_user.id)
  end
end
