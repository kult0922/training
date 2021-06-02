# frozen_string_literal: true

class LabelsController < ApplicationController
  before_action :set_label, only: %i[edit update destroy]

  def index
    @labels = current_user.labels
  end

  def new
    @label = Label.new
  end

  def create
    @label = current_user.labels.new(label_params)
    if @label.save
      redirect_to labels_path, notice: t('message.label.create.succeeded')
    else
      flash.now[:alert] = t('message.label.create.failed')
      render :new
    end
  end

  def update
    if @label.update(label_params)
      redirect_to labels_path, notice: t('message.label.update.succeeded')
    else
      flash.now[:alert] = t('message.label.update.failed')
      render :edit
    end
  end

  def destroy
    if @label.destroy
      redirect_to labels_path, notice: t('message.label.delete.succeeded')
    else
      redirect_to labels_path, alert: t('message.label.delete.failed')
    end
  end

  private

  def set_label
    @label = current_user.labels.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to labels_path, alert: t('activerecord.errors.models.label.not_found')
  end

  def label_params
    params.require(:label).permit(:name)
  end
end
