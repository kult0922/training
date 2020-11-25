class TasksController < ApplicationController
  def index
    @users = User.all
  end

  def new
    @user = Tasks.new
  end

  def create
    @user = Tasks.new(user.params)
    @user.save
      redirect_to users_path
    #  else
     # render 'new'
  end
  
  def edit
      @user = Tasks.find(params[:id])
  end

  def update
      @user = Tasks.find(params[:id])
      if @user.update(user_params)
          redirect_to users_path
      else
      render 'edit'
    end
  end

  def show
      @user = Tasks.find(params[:id])
  end
end
