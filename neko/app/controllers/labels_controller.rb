class LabelsController < ApplicationController
  before_action :set_label, only: [:edit, :update, :destroy]
  before_action :logged_in_user
  MODEL_NAME = Label.model_name.human
  PER = 20

  def index
    @labels = Label.preload(:tasks).all.page(params[:page]).per(PER)
  end

  def new
    @label = Label.new
  end

  def create
    action_name = I18n.t('create')
    @label = Label.new(label_params)

    if @label.save
      flash[:success] = I18n.t('flash.model.succeeded', target: MODEL_NAME, action: action_name)
      redirect_to labels_path
    else
      flash.now[:danger] = I18n.t('flash.model.failed', target: MODEL_NAME, action: action_name)
      render :new
    end
  end

  def edit; end

  def update
    action_name = I18n.t('update')

    if @label.update(label_params)
      flash[:success] = I18n.t('flash.model.succeeded', target: MODEL_NAME, action: action_name)
      redirect_to labels_path
    else
      flash.now[:danger] = I18n.t('flash.model.failed', target: MODEL_NAME, action: action_name)
      render :edit
    end
  end

  def destroy
    action_name = I18n.t('delete')

    if @label.destroy
      flash[:success] = I18n.t('flash.model.succeeded', target: MODEL_NAME, action: action_name)
      redirect_to labels_path
    else
      flash.now[:danger] = I18n.t('flash.model.failed', target: MODEL_NAME, action: action_name)
      render :index
    end
  end

  private

  def set_label
    @label = Label.find(params[:id])
  end

  def label_params
    params.require(:label).permit(:name)
  end
end
