# frozen_string_literal: true

class TasksController < ApplicationController
  def index
    return redirect_to login_path unless current_user

    if params[:search_form]
      @search_form = SearchForm.new(search_form_params)
    else
      @search_form = SearchForm.new
      @search_form.sort_direction = 'desc'
    end
    @tasks = Task.search_with_condition(@search_form, params[:page], current_user)
  end

  def show
    redirect_to tasks_path
  end

  def update
    @task = Task.find(params[:id])

    if @task.update(task_params)
      flash.notice = as_success_message(@task.name, 'action-update')
      redirect_to tasks_path
    else
      flash.alert = error_message
      render 'edit'
    end
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    @task.app_user = current_user
    if @task.save
      flash.notice = as_success_message(@task.name, 'action-create')

      redirect_to tasks_path
    else
      flash.alert = error_message
      render 'new'
    end
  end

  def destroy
    task = Task.find(params[:id])
    task.destroy!
    flash.notice = as_success_message(task.name, 'action-delete')

    redirect_to tasks_path
  end

  def edit
    @task = Task.find(params[:id])
  end

  private

  def task_params
    params.require(:task).permit(:name, :due_date, :status)
  end

  def search_form_params
    params.require(:search_form).permit(:sort_direction, :status)
  end

  def as_success_message(name, action_key)
    I18n.t('msg-success', name: name, action: t(action_key))
  end

  def error_message
    I18n.t('msg-error')
  end
end