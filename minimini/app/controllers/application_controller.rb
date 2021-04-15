class ApplicationController < ActionController::Base
    protect_from_forgery
    
    rescue_from StandardError, with: :render_500
    rescue_from ActionController::RoutingError, with: :render_404
    rescue_from ActiveRecord::RecordNotFound, with: :render_404

    def render_404
        render file: Rails.root.join('public/404.html'), status: 404, layout: false, content_type: 'text/html'
    end

    def render_500
        render file: Rails.root.join('public/404.html'), status: 500, layout: false, content_type: 'text/html'
    end

    include SessionsHelper

    private
        def require_login
            unless is_logged_in?
                redirect_to login_path
            end
        end

        def is_logged_in?
            !session[:user_id].nil?
        end

        def log_in(user)
            session[:user_id] = user.id
        end
end
