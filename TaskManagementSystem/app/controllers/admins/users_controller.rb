class Admins::UsersController < ApplicationController

  def index
    @users = User.all.page(params[:page]).per(10)
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create

  end

  def edit
    @user = User.find(params[:id])
  end

  def update

  end

  def destroy

  end

  private
  
end