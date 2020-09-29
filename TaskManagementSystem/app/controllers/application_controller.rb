# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include SessionsHelper
  
  before_action :render_maintenance_page

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

  # ユーザー管理画面にログイン中の管理ユーザを取得
  def admin_user_initialize
    @admin_user = User.find(session[:user_id])
  rescue StandardError => e
    redirect_to admin_login_path, danger: '存在しないユーザーです'
  end

  # メンテナンス
  def render_maintenance_page
    render file: Rails.public_path.join('maintenance.html'), layout: false if File.exist?('config/tmp/maintenance.yml')
  end
end
