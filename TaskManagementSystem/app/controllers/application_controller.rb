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
  def redirect_to_login_if_not_logged_in
    unless logged_in?
      flash[:danger] = I18n.t('flash.please_login')
      redirect_to login_path
    end
  end  
end
