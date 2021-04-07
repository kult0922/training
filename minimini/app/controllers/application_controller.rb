class ApplicationController < ActionController::Base
    before_action :psudo_auto_login_for_test
    
    # ログイン実装後、削除
    def psudo_auto_login_for_test
        session[:user_id] = "1111"
    end
end
