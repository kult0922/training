# frozen_string_literal: true

module Api
  class TasksController < Api::ApiController
    before_action :logged_in_user

    def search
      query = current_user.tasks.includes(:labels).ransack(search_params)
      task_count = query.result.count
      tasks = query.result.order(created_at: :desc).page params[:page]
      render json: { tasks: tasks.map { |t| response_task(t) }, count: task_count }
    end

    def create
      task = current_user.tasks.new(task_params.except(:attach_labels))
      task = TaskService.new(task).create_task(task_params)
      errors = task.errors
      if errors.blank?
        render json: { message: I18n.t('view.task.flash.created') }
      else
        render json: { message: task.errors }, status: :bad_request
      end
    end

    def update
      task = current_user.tasks.find_by(id: params[:id])
      return render json: { message: I18n.t('view.task.error.not_found') }, status: :not_found unless task

      task = TaskService.new(task).update_task(task_params)
      if task.errors.blank?
        render json: { message: I18n.t('view.task.flash.updated') }
      else
        render json: { message: task.errors }, status: :bad_request
      end
    end

    def destroy
      task = current_user.tasks.find_by(id: params[:id])
      return render json: { message: I18n.t('view.task.error.not_found') }, status: :not_found unless task

      if task.destroy
        render json: { message: I18n.t('view.task.flash.deleted') }
      else
        render json: { message: task.errors }, status: :bad_request
      end
    end

    private

    def response_task(task_with_label)
      {
        id: task_with_label.id,
        name: task_with_label.name,
        description: task_with_label.description,
        status: task_with_label.status,
        attach_labels: task_with_label.labels.map { |l| { id: l.id, name: l.name } },
        target_date: task_with_label.target_date,
        created_at: task_with_label.created_at,
      }
    end

    def task_params
      params.require(:task).permit(:name, :description, :target_date, :status, :priority, { attach_labels: [] })
    end

    def search_params
      JSON.parse(params[:query])
    end
  end
end
