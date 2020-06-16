class Admin::Base < ActionController::Base
  include ErrorHandlers if Rails.env.production? || Rails.env.test?
  include Admin::Sessions
  include Maintenance

  layout 'admin'
end
