# frozen_string_literal: true

class Admin::TasksController < ApplicationController
  helper TasksHelper
  before_action :set_task, only: %i[show edit update destroy]

  def index
    @tasks = Task.where(user_id: params[:id])
                 .task_search(title: params[:title], status: params[:status], sort: params[:sort], direction: params[:direction])
                 .page(params[:page])
                 .per(10)
    @user = User.find(params[:id])
    render template: 'tasks/index'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_task
    @task = Task.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def task_params
  end
end
