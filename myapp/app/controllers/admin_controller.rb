class AdminController < ApplicationController
  before_action :require_admin_privilege

  def index; end

end
