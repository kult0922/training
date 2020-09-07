class SessionsController < ApplicationController
  
  def new
    @user = User.new
  end

  def create
    user = User.find_by(email: params[:email].downcase)
    if user && user.authenticate(params[:password])
      # ユーザーログイン後にユーザー情報のページにリダイレクトする
      log_in(user)
      redirect_to root_path, success: 'ログインしました。'
    else
      flash.now[:danger] = 'ログインに失敗しました。'
      render :new
    end
  end

  def destroy
    log_out
    redirect_to login_path
  end
end