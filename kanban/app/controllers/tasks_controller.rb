class TasksController < ApplicationController
  def index
    @all_tasks = Task.all
  end
end
