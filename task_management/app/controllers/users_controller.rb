class UsersController < ApplicationController
  attr_reader :user

  def index

  end

  def login
    user = User.select(:id, :name, :authority_id).find_by(login_id: params[:login_id], password: params[:password])
    if user.nil?
      flash[:alert] = 'ログインに失敗しました。'
      render :index
    else
      redirect_to controller: :tasks, action: :index
    end
  end

  def user_params
    params.require(:user).permit(:login_id, :password)
  end

end
