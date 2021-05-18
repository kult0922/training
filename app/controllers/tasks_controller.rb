class TasksController < ApplicationController
    before_action :set_task, only: [:show, :edit, :update, :destroy]

    def index
        @tasks = Task.all
    end

    def new
        @task = Task.new
    end

    def create
        @task = Task.new(task_params)
        if @task.save
            redirect_to @task, notice: 'Successfully created a task'
        else
            flash[:alert] = 'Failed to create a task'
            render :new
        end
    end

    def update
        if @task.update(task_params)
            redirect_to @task, notice: 'Successfully updated a task'
        else
            flash[:alert] = 'Failed to update a task'
            render :edit
        end
    end

    def destroy
        if @task.destroy
            redirect_to root_path, notice: 'Successfully destroyed a task'
        else
            redirect_to root_path, alert: 'Failed to destroy a task'
        end
    end

    private

    def set_task
        @task = Task.find(params[:id])
    end

    def task_params
        params.require(:task).permit(:title, :description)
    end
end
