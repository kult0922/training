class TasksController < ApplicationController

    def index
        @tasks = Task.all.order(created_at: :desc)
    end

    def newtask
        render "newtask"
    end

    def createtask
        
    end
end
