# frozen_string_literal: true

module Tasks
  class CompletionsController < ApplicationController
    def index
      Task.find(params[:task_id]).complete!
      redirect_to root_path
    end
  end
end
