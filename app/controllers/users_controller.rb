class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy
  before_action :find_user, only: [:show, :destroy, :edit, :update]

  def show
    redirect_to signup_path if @user.nil?
  end

  def index
    @users = User.paginate page: params[:page], per_page: 5
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_param
    if @user.save
      log_in @user
      flash[:success] = t("sign_up.welcome")
      redirect_to @user
    else
      render :new
    end
  end

  def destroy
    @user.destroy
    flash[:success] = t(".delete_noti")
    redirect_to users_url
  end

  def edit
  end

  def update
    flash[:success] = t("users.update.profile_updated")
    if @user.update_attributes user_param
      redirect_to @user
    else
      render :edit
    end
  end

  def logged_in_user
    return if logged_in?
    store_location
    flash[:danger] = t("users.update.flash_login")
    redirect_to login_path
  end

  def correct_user
    @user = User.find_by id: params[:id]
    redirect_to root_url unless current_user? @user
  end

  def admin_user
    redirect_to root_path unless current_user.admin?
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
