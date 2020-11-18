class TasksController < ApplicationController

    def index
        @tasks = Task.all.order(created_at: :desc)
    end

    def newtask
        @task = Task.new
        render "newtask"
    end

    def createtask
        
    end
end
