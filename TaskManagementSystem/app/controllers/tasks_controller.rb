class TasksController < ApplicationController
	before_action :set_task, only: %i[show edit update destroy]

	def index
		@tasks = Task.all	
  end

	def new
		@task = Task.new
	end
	
	def create
		@task = Task.new(task_params)
		if @task.save
			redirect_to task_path(@task), success: "新しいタスクを作成しました"
		else
			flash.now[:danger] = "タスクの作成に失敗しました"
			render :new
		end
	end

	def show
  end

	def edit
	end

	def update
		if @task.update_attributes(task_params)
			redirect_to task_path(@task)
		else
			flash.now[:danger] = "タスクの更新に失敗しました"
			render :edit
		end
	end

	def destroy
		if @task.destroy
			redirect_to tasks_index_path, success: "タスクを削除しました"
		end
	end
	
	private

	def set_task
		@task = Task.find_by(id: params[:id])
		if @task.present?
			return @task
		else
			redirect_to tasks_index_path, danger: "存在しないタスクです"
		end
	end

	def task_params
		params.require(:task).permit(:user_id, :name, :description, :priority, :status, :deadline)
	end
end
