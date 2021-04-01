class LabelsController < ApplicationController
  before_action :set_label_if_admin_or_owner, only: [:edit, :update, :destroy]
  before_action :logged_in_user
  MODEL_NAME = Label.model_name.human

  def index
    @labels = Label.preload(:tasks).eager_load(:user).all.page(params[:page])
  end

  def new
    @label = Label.new
  end

  def create
    @label = current_user.labels.new(label_params)

    if @label.save
      flash[:success] = I18n.t('flash.model.succeeded', target: MODEL_NAME, action: I18n.t(action_name))
      redirect_to labels_path
    else
      flash.now[:danger] = I18n.t('flash.model.failed', target: MODEL_NAME, action: I18n.t(action_name))
      render :new
    end
  end

  def edit; end

  def update
    if @label.update(label_params)
      flash[:success] = I18n.t('flash.model.succeeded', target: MODEL_NAME, action: I18n.t(action_name))
      redirect_to labels_path
    else
      flash.now[:danger] = I18n.t('flash.model.failed', target: MODEL_NAME, action: I18n.t(action_name))
      render :edit
    end
  end

  def destroy
    if @label.destroy
      flash[:success] = I18n.t('flash.model.succeeded', target: MODEL_NAME, action: I18n.t(action_name))
      redirect_to labels_path
    else
      flash.now[:danger] = I18n.t('flash.model.failed', target: MODEL_NAME, action: I18n.t(action_name))
      render :index
    end
  end

  private

  def set_label_if_admin_or_owner
    @label = Label.find(params[:id])
    not_permit('flash.admin_or_owner.permit') unless current_user.administrator? || owner?(@label)
  end

  def label_params
    params.require(:label).permit(:name)
  end
end