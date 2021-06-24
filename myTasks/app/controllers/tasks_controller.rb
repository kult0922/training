class TasksController < ApplicationController
    def list
        @tasks = Task.all
    end

    def detail
        @task = Task.find(params[:id])
    end

    def new
        @task = Task.new
    end

    def create
        @task = Task.new(task_params)
        
        if @task.save
            flash[:notice] = "Create Task!"
            redirect_to "/"
        else
            render "new"
        end
    end

    def edit
        @task = Task.find(params[:id])
    end

    def update
        @task = Task.find(params[:id])
        
        if @task.update(task_params)
            flash[:notice] = "Update Task!"
            redirect_to "/"
        else
            render "edit"
        end
    end

    def destroy
        @task = Task.find(params[:id])
        if @task.destroy
            flash[:notice] = "Delete Task!"
            redirect_to "/"
        end
    end

    private
        def task_params
            params.require(:task).permit(:name, :description, :end_date, :priority)
        end
end
