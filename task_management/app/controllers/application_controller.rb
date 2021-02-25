# frozen_string_literal: true

# アプリケーションコントローラー
class ApplicationController < ActionController::Base
  include Common

  unless Rails.env.development?
    rescue_from Exception, with: :render_500
    rescue_from ActiveRecord::RecordNotFound, with: :render_404
    rescue_from ActionController::RoutingError, with: :render_404
  end
end
