# frozen_string_literal: true

class Tasks::CompletionsController < ApplicationController

  def index
    Task.find(params[:task_id]).complete!
    redirect_to root_path
  end
end
