class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy
  before_action :find_user, only: [:show, :destroy, :edit, :update]

  def show
    if @user&.activated
      @microposts = @user.microposts.paginate(page: params[:page],
        per_page: Settings.maximum.max_user_per_page)
      return @user
    else
      redirect_to signup_path
    end
  end

  def index
    @users = User.where(activated: true)
                 .paginate page: params[:page],
                           per_page: Settings.maximum.max_user_per_page
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_param
    if @user.save
      @user.send_activation_email
      flash[:info] = t("users.create.check_your_email")
      redirect_to root_url
    else
      flash.now[:danger] = t("users.create.error")
      render :new
    end
  end

  def destroy
    @user.destroy
    flash[:success] = t("users.destroy.delete_noti")
    redirect_to users_url
  end

  def edit; end

  def update
    flash[:success] = t "users.update.profile_updated"
    if @user.update_attributes user_param
      redirect_to @user
    else
      render :edit
    end
  end

  def correct_user
    @user = User.find_by id: params[:id]
    redirect_to root_url unless current_user? @user
  end

  def admin_user
    redirect_to root_path unless current_user.admin?
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  private

  def user_param
    params.require(:user).permit :name, :email, :password,
      :password_confirmation
  end

  def find_user
    @user = User.find_by id: params[:id]
    if @user.nil?
      redirect_to root_path
      flash[:danger] = t "users.cant_find_user"
    end
  end
end
