class SessionsController < ApplicationController
  
  def new
    @user = User.new
  end

  def create
    @user = User.new
    render :new
  end

  def destroy

  end
end