class Admin::UsersController < ApplicationController
  before_action :set_user, only: [:show]

  def index
    @users = User.all.order(created_at: :desc, id: :desc)
  end

  def show; end

  def new; end
  def create; end
  def update; end
  def delete; end

  private

  def set_user
    @user = User.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render status: :not_found, template: 'errors/404', locals: { message: 'User not found' }
  end

end
