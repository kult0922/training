# frozen_string_literal: true

class ProjectsController < ApplicationController
  before_action :set_project, only: %i[show edit update destroy]
  before_action :logged_in_user

  def index
    @projects = Project.all
    @status_list = Project.statuses.keys
    @user_have_pj = current_user.projects.ids
  end

  def show
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(project_params)
    @project.user_projects.new(user_id: current_user.id)
    if @project.save
      flash[:notice] = I18n.t('flash.succeeded', model: 'プロジェクト', action: '作成')
      redirect_to projects_url
    else
      flash.now[:error] = I18n.t('flash.failed', model: 'プロジェクト', action: '作成')
      render :new
    end
  end

  def edit
  end

  def update
    if @project.update(project_params)
      redirect_to projects_url
      flash[:notice] = I18n.t('flash.succeeded', model: 'プロジェクト', action: '更新')
    else
      flash.now[:error] = I18n.t('flash.failed', model: 'プロジェクト', action: '更新')
      render :edit
    end
  end

  def destroy
    return unless current_user.projects.include?(@project)
    if @project.destroy
      flash[:notice] = I18n.t('flash.succeeded', model: 'プロジェクト', action: '削除')
      redirect_to projects_url
    else
      flash.now[:error] = I18n.t('flash.failed', model: 'プロジェクト', action: '削除')
      render :index
    end
  end

  private

  def set_project
    @project = Project.find(params[:id])
  end

  def project_params
    params.require(:project).permit(:project_name, :description, :status, :started_at, :finished_at)
  end
end
