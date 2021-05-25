# frozen_string_literal: true

class Tasks::FiltersController < ApplicationController

  def index
    @tasks = Task.public_send(params[:state]).sort_by(&:priority)
    render 'tasks/index'
  end
end
