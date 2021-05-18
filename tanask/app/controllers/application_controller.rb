class ApplicationController < ActionController::Base
end

class Forbidden < ActionController::ActionControllerError; end
class IpAddressRejected < ActionController::ActionControllerError; end

include ErrorHandlers if Rails.env.production? or Rails.env.staging?