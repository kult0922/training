# frozen_string_literal: true

module Tasks
  class StartsController < ApplicationController
    def index
      current_user.tasks.find(params[:task_id]).start!
      redirect_to tasks_path
    end
  end
end
