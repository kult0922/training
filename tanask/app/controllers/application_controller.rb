class ApplicationController < ActionController::Base
  class Forbidden < ActionController::ActionControllerError; end

  class IpAddressRejected < ActionController::ActionControllerError; end

  include ErrorHandlers if Rails.env.production? || Rails.env.staging? || Rails.env.test?
end
