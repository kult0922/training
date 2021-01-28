# frozen_string_literal: true

module Admin
  class AdminController < ApplicationController
    before_action :admin_check

    def admin_check
      redirect_to login_path unless admin?
    end
  end
end
