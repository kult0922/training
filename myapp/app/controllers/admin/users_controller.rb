class Admin::UsersController < ApplicationController

  def index
    @users = User.all.order(created_at: :desc, id: :desc)
  end

  def show; end
  def new; end
  def create; end
  def update; end
  def delete; end

end
