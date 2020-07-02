class LabelsController < ApplicationController
  before_action :check_admin_user
  before_action :find_label, only: %i[show edit update destroy]
  PER = 5

  def index
    @labels = Label.all.page(params[:page]).per(PER)
  end

  def new
    @label = Label.new
  end

  def create
    @label = Label.new(label_params)

    if @label.save
      flash[:success] = t '.flash.success', action: t('.sakusei')
      redirect_to labels_path
    else
      flash.now[:danger] = t '.flash.danger', action: t('.sakusei')
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @label.update(label_params)
      flash[:success] = t '.flash.success', action: t('.koushin')
      redirect_to label_path
    else
      flash.now[:danger] = t '.flash.danger', action: t('.koushin')
      render :edit
    end
  end

  def destroy
    @label.destroy
    flash[:success] = t '.flash.success', action: t('.delete')
    redirect_to labels_path
  end

  private

  def label_params
    params.require(:label).permit(:name)
  end

  def find_label
    @label = Label.find(params[:id])
  end

  def check_admin_user
    redirect_to tasks_path unless current_user.admin?
  end
end
