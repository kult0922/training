class LabelsController < ApplicationController
  before_action :logged_in_user

  def index
    @labels = current_user.labels.includes(:user).page(params[:page])
  end

  def new
    @label = Label.new
  end

  def create
    @label = current_user.labels.new(label_params)
    if @label.valid?
      @label.save
      redirect_to labels_url, notice: I18n.t('labels.flash.create', name: @label.name)
    else
      render :new
    end
  end

  def destroy
    @label = Label.find(params[:id])
    @label.destroy
    redirect_to labels_url, notice: I18n.t('labels.flash.delete', name: @label.name)
  end

  private

  def label_params
    params.require(:label).permit(:name)
  end
end
