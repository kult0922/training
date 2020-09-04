# frozen_string_literal: true

class LabelsController < ApplicationController
  before_action :set_label, only: %i[edit update destroy]
  before_action :logged_in_user

  def index
    @labels = Label.all.page(params[:page]).per(20)
    @project_id = params[:project_id]
  end

  def new
    @label = Label.new
  end

  def create
    @label = Label.new(label_params)
    if @label.save
      flash[:notice] = I18n.t('flash.succeeded', model: 'ラベル', action: '作成')
      redirect_to labels_path
    else
      flash.now[:error] = I18n.t('flash.failed', model: 'ラベル', action: '作成')
      render :new
    end
  end

  def edit
  end

  def update
    if @label.update(label_params)
      flash[:notice] = I18n.t('flash.succeeded', model: 'ラベル', action: '更新')
      redirect_to labels_path
    else
      flash.now[:error] = I18n.t('flash.failed', model: 'ラベル', action: '更新')
      render :edit
    end
  end

  def destroy
    if @label.destroy
      flash[:notice] = I18n.t('flash.succeeded', model: 'ラベル', action: '削除')
      redirect_to labels_path
    else
      flash.now[:error] = I18n.t('flash.failed', model: 'ラベル', action: '削除')
      render :index
    end
  end

  def set_label
    @label = Label.find(params[:id])
  end

  def label_params
    params.require(:label).permit(:color, :text)
  end
end
