# frozen_string_literal: true

module Tasks
  class StartsController < ApplicationController
    def index
      Task.find(params[:task_id]).start!
      redirect_to root_path
    end
  end
end
