class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy]

  def index
    @projects = Project.all
  end

  def show
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(project_params)

    if @project.save
      flash[:notice] = 'プロジェクトが追加されました。' 
      redirect_to @project
    else
      flash[:error] = 'プロジェクトが追加に失敗しました。'
      render :new
    end
  end

  def edit
  end

  def update
    if @project.update(project_params)
      flash[:notice] = 'プロジェクトが更新されました。' 
      redirect_to @project
    else
      flash[:error] = 'プロジェクトが更新に失敗しました。'
      render :edit
    end
  end

  def destroy
    if @project.destroy
      flash[:notice] = 'プロジェクトが削除されました。'
      redirect_to @project
    else
      flash[:error] = 'プロジェクトが削除に失敗しました。'
      render :edit
    end
  end

  def set_project
    @project = Project.find(params[:id])
  end

  def project_params
    params.require(:project).permit(:project_name, :description, :status, :started_at, :finished_at)
  end
end
