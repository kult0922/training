class Admin::Base < ActionController::Base
  include ErrorHandlers if Rails.env.production? || Rails.env.test?
  include Admin::Sessions

  layout 'admin'
end
