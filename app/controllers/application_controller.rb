# frozen_string_literal: true

class ApplicationController < ActionController::Base
  helper_method :current_user
  before_action :login

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def login
    redirect_to new_session_path unless current_user
  end
end
