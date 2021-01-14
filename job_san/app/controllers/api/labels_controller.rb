# frozen_string_literal: true

module Api
  class LabelsController < Api::ApiController
    before_action :logged_in_user

    def index
      render json: { labels: Label.all }
    end
  end
end
