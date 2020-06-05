class ApplicationController < ActionController::Base
  include ErrorHandlers if Rails.env.production? || Rails.env.test?
  include Sessions
end
