module Admin
  class AdminBase < ApplicationController
    before_action :check_admin

    def check_admin
      unless current_user.admin?
        raise IllegalAccessError
      end
    end
  end
end