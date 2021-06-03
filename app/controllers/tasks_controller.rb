# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :set_task, only: %i[show edit update destroy]

  def index
    @q = current_user.tasks.includes(:labels).ransack(params[:q])
    @q.sorts = 'priority asc' if @q.sorts.empty?
    @tasks = @q.result(distinct: true).page(params[:page])
  end

  def new
    @task = Task.new
  end

  def create
    @task = current_user.tasks.new(task_params)
    if @task.save
      redirect_to @task, notice: t('message.task.create.succeeded')
    else
      flash.now[:alert] = t('message.task.create.failed')
      render :new
    end
  end

  def edit
    @task_label_ids = @task.labels.pluck(:id) # For checkbox status
  end

  def update
    if @task.update(task_params)
      redirect_to @task, notice: t('message.task.update.succeeded')
    else
      flash.now[:alert] = t('message.task.update.failed')
      render :edit
    end
  end

  def destroy
    if @task.destroy
      redirect_to tasks_path, notice: t('message.task.delete.succeeded')
    else
      redirect_to tasks_path, alert: t('message.task.delete.failed')
    end
  end

  private

  def set_task
    @task = current_user.tasks.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to tasks_path, alert: t('activerecord.errors.models.task.not_found')
  end

  def task_params
    # When all labels were unchecked on update, merge empty array because 'label_ids' won't be sent.
    params.require(:task).permit(:title,
                                 :description,
                                 :priority,
                                 label_ids: []).to_h.merge(label_ids: []) { |_key, old_val, new_val| old_val || new_val }
  end
end
