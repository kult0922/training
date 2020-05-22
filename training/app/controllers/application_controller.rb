class ApplicationController < ActionController::Base
  include ErrorHandlers if Rails.env.production?
end
