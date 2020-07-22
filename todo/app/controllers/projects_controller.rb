# frozen_string_literal: true

class ProjectsController < ApplicationController
  before_action :set_project, only: %i[show edit update destroy]

  def index
    @todo_projects = Project.where(status: :todo)
    @progress_projects = Project.where(status: :in_progress)
    @review_projects = Project.where(status: :in_review)
    @relese_projects = Project.where(status: :release)
    @resolved_projects = Project.where(status: :done)
  end

  def show
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(project_params)

    if @project.save
      redirect_to projects_url
      flash[:notice] = 'プロジェクトが追加されました。'
    else
      render :new
      flash[:error] = 'プロジェクトが追加に失敗しました。'
    end
  end

  def edit
  end

  def update
    if @project.update(project_params)
      redirect_to projects_url
      flash[:notice] = 'プロジェクトが更新されました。'
    else
      render :edit
      flash[:error] = 'プロジェクトが更新に失敗しました。'
    end
  end

  def destroy
    if @project.destroy
      flash[:notice] = 'プロジェクトが削除されました。'
      redirect_to projects_url
    else
      render :edit
      flash[:error] = 'プロジェクトが削除に失敗しました。'
    end
  end

  def set_project
    @project = Project.find(params[:id])
  end

  def project_params
    params.require(:project).permit(:project_name, :description, :status, :started_at, :finished_at)
  end
end
