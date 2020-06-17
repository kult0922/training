class ApplicationController < ActionController::Base
  # テスト環境でも本番同様にエラー画面を表示させたいためにRails.env.test?を追加
  include ErrorHandlers if Rails.env.production? || Rails.env.test?
  include Sessions
  include Maintenance
end
