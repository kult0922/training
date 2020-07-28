class LabelsController < ApplicationController
  before_action :set_label, only: %i[edit update destroy]

  def index
    @labels = current_user.labels.page(params[:page])
  end

  def new
    @label = Label.new
  end

  def create
    @label = current_user.labels.new(label_params)
    if @label.save
      redirect_to labels_path, notice: I18n.t('labels.flash.create')
    else
      render :new
    end
  end

  def update
    if @label.update(label_params)
      redirect_to labels_path, notice: I18n.t('labels.flash.update')
    else
      render :edit
    end
  end

  def destroy
    @label.destroy if redirect_to labels_path, notice: I18n.t('labels.flash.destroy')
  end

  private

  def label_params
    params.require(:label).permit(:name)
  end

  def set_label
    @label = current_user.labels.find(params[:id])
  end
end
