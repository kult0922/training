class SessionsController < ApplicationController
  attr_reader :user

  def index
    return unless logged_in?
    redirect_to controller: :tasks, action: :index
  end

  # TODO: パスワードの暗号化はステップ18で行う（password→password_digest）
  def create
    user = User.select(:id, :name, :authority_id)
               .find_by(login_id: params[:login_id],
                        password: params[:password])
    if user.nil?
      flash[:alert] = 'ログインIDかパスワードを確認してください。'
      render :index
    else
      log_in(user)
      flash[:alert] = ''
      redirect_to controller: :tasks, action: :index
    end
  end

  def destroy
    log_out
    flash[:notice] = 'ログアウトしました。'
    redirect_to action: :index
  end

  private

  def session_params
    params.require(:user).permit(:login_id, :password)
  end
end
