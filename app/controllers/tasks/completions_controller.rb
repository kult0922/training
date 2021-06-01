# frozen_string_literal: true

module Tasks
  class CompletionsController < ApplicationController
    def index
      current_user.tasks.find(params[:task_id]).complete!
      redirect_to tasks_path
    end
  end
end
