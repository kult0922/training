class TaskController < ApplicationController
  def index
    @task = Task.all
  end

  def new
  end

  def show
  end

  def edit
  end
end
