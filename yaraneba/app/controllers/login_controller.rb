# frozen_string_literal: true

class LoginController < ApplicationController
  before_action :redirect_logged_in_user, except: :destroy

  def new
  end

  def create
    @user = User.find_by(email: params[:email])
    if @user&.authenticate(params[:password])
      save_user_info_to_session
      redirect_to tasks_path
    else
      redirect_to login_path, alert: I18n.t('notice.fault')
    end
  end

  def destroy
    delete_user_info_in_session
    redirect_to root_path
  end
end
