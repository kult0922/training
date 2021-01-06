class SessionsController < ApplicationController
  attr_reader :user

  def index
    user_id = session[:user_id]
    user = User.find(user_id) if user_id
    return if user.blank?
    redirect_to controller: :tasks, action: :index
  end

  def create
    user = User.select(:id, :name, :authority_id).find_by(login_id: params[:login_id], password: params[:password])
    if user.nil?
      flash[:alert] = 'ログインIDかパスワードを確認してください。'
      render :index
    else
      flash[:alert] = ''
      session[:user_id] = user.id
      redirect_to controller: :tasks, action: :index
    end
  end

  def destroy
    session.delete(:user_id)
    flash[:notice] = 'ログアウトしました。'
    redirect_to action: :index
  end

  private

  def session_params
    params.require(:user).permit(:login_id, :password)
  end
end
