class Admin::UsersController < AdminController
  before_action :set_user, only: [:show, :update, :destroy]

  def index
    @users = User.all.order(created_at: :desc, id: :desc)
  end

  def show; end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.invalid?
      render :new
    elsif @user.save
      redirect_to admin_user_url(@user), notice: I18n.t('admin.users.notice_user_created')
    else
      render :new
    end
  end

  def update
    if @user.update(user_params)
      redirect_to admin_user_url(@user), notice: I18n.t('notice_updated')
    else
      render :show
    end
  end

  def destroy
    if User.where(role: :admin).count <= 1
      render :show, locals: { notice: I18n.t('admin.users.notice_cannot_delete_the_last_admin') }
    else
      @user.destroy
      redirect_to admin_users_url, notice: I18n.t('notice_deleted')
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render status: :not_found, template: 'errors/404', locals: { message: I18n.t('admin.users.not_found') }
  end

  def user_params
    params.fetch(:user, {}).permit(:name, :email, :role, :password, :password_confirmation)
  end

end
