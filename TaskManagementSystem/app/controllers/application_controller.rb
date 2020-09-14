# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include SessionsHelper

  # bootstrapを使用したフラッシュメッセージ用
  add_flash_types :success, :info, :warning, :danger

  # 例外処理
  rescue_from Exception, with: :rescue500 unless Rails.env.development?
  rescue_from ActiveRecord::RecordNotFound, with: :rescue404
  rescue_from ActionController::RoutingError, with: :rescue404

  private

  def rescue404(e)
    @exception = e
    render template: 'errors/not_found', status: 404
  end

  def rescue500(e)
    @exception = e
    render template: 'errors/system_error', status: 500
  end

  # ログイン済ユーザーかどうか確認
  def logged_in_user
    unless logged_in?
      flash[:danger] = I18n.t('flash.please_login')
      redirect_to login_path
    end
  end

  # ログイン済ユーザーかどうか確認（ユーザー管理画面用）
  def logged_in_admin_user
    unless logged_in?
      flash[:danger] = I18n.t('flash.please_login')
      redirect_to admin_login_path
    end
  end  
  
  # 管理者権限取得
  def set_admin_role
    @role = Role.first
  rescue => e
    redirect_to admins_users, danger: I18n.t('flash.no_admin_role')
  end

  # ユーザー管理画面にログイン中の管理ユーザを取得
  def set_admin_user
    @admin_user = User.find(session[:user_id])
  rescue StandardError => e
    redirect_to admin_login_path, danger: '存在しないユーザーです'
  end
end
