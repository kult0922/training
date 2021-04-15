# frozen_string_literal: true

class LabelsController < ApplicationController
  before_action :set_label, only: %i[edit update destroy]
  before_action :redirect_if_authorization_is_required
  before_action :redirect_if_user_not_allowed, except: %i[index]

  def index
    @labels = Label.where(user_id: session[:id])
  end

  def edit
  end

  def update
    if @label.update(name: params[:label][:name])
      redirect_to labels_path, notice: I18n.t('notice.success')
    else
      redirect_to labels_path, notice: I18n.t('notice.fault')
    end
  end

  def destroy
    if @label.destroy
      redirect_to labels_path, notice: I18n.t('notice.success')
    else
      redirect_to labels_path, notice: I18n.t('notice.fault')
    end
  end

  private

  def set_label
    @label = Label.find(params[:id])
  end

  def redirect_if_user_not_allowed
    redirect_to labels_path, notice: I18n.t('notice.fault') if @label.user_id != session[:id]
  end
end
