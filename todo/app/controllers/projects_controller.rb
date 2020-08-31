# frozen_string_literal: true

class ProjectsController < ApplicationController
  before_action :set_project, only: %i[show edit update destroy]
  before_action :logged_in_user
  before_action :check_userpj_auth, only: :destroy
  include UserProjectsHelper

  def index
    @projects = Project.all
    @status_list = Project.statuses.keys
    user_project
  end

  def show
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(project_params)
    if @project.save
      create_user_project
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
    if @project.destroy
      flash[:notice] = I18n.t('flash.succeeded', model: 'プロジェクト', action: '削除')
      redirect_to projects_url
    else
      flash.now[:error] = I18n.t('flash.failed', model: 'プロジェクト', action: '削除')
      render :index
    end
  end

  def set_project
    @project = Project.find(params[:id])
  end

  def create_user_project
    return if UserProject.find_by(user_id: session[:user_id], project_id: @project.id).present?
    user_project = UserProject.new(user_id: session[:user_id], project_id: @project.id)
    flash[:error] = I18n.t('flash.failed', model: 'ユーザプロジェクト', action: '作成') unless user_project.save
  end

  def check_userpj_auth
    user_project
    redirect_to projects_url unless @user_have_pj.include?(@project.id)
  end

  def project_params
    params.require(:project).permit(:project_name, :description, :status, :started_at, :finished_at)
  end
end
