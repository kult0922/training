# 次のステップで実装
$logged_in = true 

class ApplicationController < ActionController::Base
    before_action :require_login
    before_action :psudo_auto_login_for_test

    def require_login
        unless $logged_in then
            flash[:error] = "You must be logged in to access this section"
            redirect_to "/login"
        end
    end

    def psudo_auto_login_for_test
        session[:user_id] = "1111"
    end
end
