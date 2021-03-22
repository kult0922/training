# frozen_string_literal: true

class LoginController < ApplicationController
  before_action :redirect_logged_in_user, except: :destroy

  def new
  end

  def create
    @user = User.find_by(email: params[:email])
    if @user&.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect_to tasks_path
    else
      flash.alert = I18n.t('notice.fault')
      redirect_to login_path
    end
  end

  def destroy
    session.delete(:user_id)
    flash.notice = I18n.t('notice.success')
    redirect_to tasks_path
  end
end
