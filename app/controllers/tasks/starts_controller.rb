# frozen_string_literal: true

class Tasks::StartsController < ApplicationController

  def index
    Task.find(params[:task_id]).start!
    redirect_to root_path
  end
end
