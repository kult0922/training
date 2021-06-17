# frozen_string_literal: true

class TasksController < ApplicationController
  def index
    @tasks = Task.all.order(created_at: :desc)
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    return true if @task.save!

    flash[:success] = I18n.t(:'message.registered_task')
    redirect_to root_path
  end

  def show
    @task = Task.find_by(id: params[:id])
  end

  def edit
    @task = Task.find_by(id: params[:id])
  end

  def update
    @task = Task.find_by(id: params[:id])
    return true if @task.update!(task_params)

    flash[:success] = I18n.t(:'message.edited_task')
    redirect_to root_path
  end

  def destroy
    @task = Task.find_by(id: params[:id])
    @task.delete

    flash[:success] = I18n.t(:'message.deleted_task')
    redirect_to root_path
  end

  def task_params
    params.require(:task).permit(:title, :description)
  end
end
