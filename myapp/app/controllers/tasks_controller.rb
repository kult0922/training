# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :find_task_by_id, only: %i[show edit]

  def index
    @tasks = Task.all
  end

  def new
    @task = Task.new
  end

  def show
  end

  def edit
  end

  def create
    @task = Task.new(permitted_tasks_params)
    if @task.save
      redirect_to root_path, notice: 'Added task'
    else
      redirect_to root_path, notice: 'Failure added task' # TODO: fix path
    end
  end

  def update
    @task = Task.find(params[:id])
    if @task.update(permitted_tasks_params)
      redirect_to root_path, notice: 'Edited task'
    else
      redirect_to root_path, notice: 'Failure edited task' # TODO: fix path
    end
  end

  def destroy
    Task.find(params[:id]).destroy!
    redirect_to root_path, notice: 'Deleted task'
  end

  private

  def permitted_tasks_params
    params.require(:task).permit(
      :title,
      :discription,
    )
  end

  def find_task_by_id
    @task = Task.find(params[:id])
  end
end
