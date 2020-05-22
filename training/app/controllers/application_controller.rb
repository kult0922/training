class ApplicationController < ActionController::Base
  include ErrorHandlers unless Rails.env.production?
end
