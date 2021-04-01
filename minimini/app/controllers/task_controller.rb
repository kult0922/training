class TaskController < ApplicationController
  before_action :fetch_task, only: %i[view update destroy]

  def create
    @task = Task.new
  end

  def view
  end

  def update
    @task = Task.search(params[:id])
  end

  def destroy
  end

  def list
    @tasks = Task.search("1111")
  end

  def fetch_task
    @task = Task.find(params[:id])
  end
end
