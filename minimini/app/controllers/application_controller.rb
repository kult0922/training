class ApplicationController < ActionController::Base
    before_action :psudo_auto_login_for_test
    
    # ログイン実装後、削除
    def psudo_auto_login_for_test
        session[:user_id] = "1111"
    end

    rescue_from StandardError, with: :render_500
    rescue_from ActionController::RoutingError, with: :render_404
    rescue_from ActiveRecord::RecordNotFound, with: :render_404

    def render_404
        render file: Rails.root.join('public/404.html'), status: 404, layout: false, content_type: 'text/html'
    end

    def render_500
        render file: Rails.root.join('public/404.html'), status: 500, layout: false, content_type: 'text/html'
    end
end
