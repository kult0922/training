class TasksController < ApplicationController
	def index
		@tasks = Task.all	
  end

	def new
		@task = Task.new	
  end

  def show
  end

	def edit
		@task = Task.find_by(id: params[:id])
  end
end
