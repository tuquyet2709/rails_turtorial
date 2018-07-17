class PasswordResetsController < ApplicationController
  before_action :find_user, only: :create
  before_action :get_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  def new; end

  def edit; end

  def create
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t "password_resets.create.email_send_with_password_reset"
      redirect_to root_url
    else
      flash.now[:danger] = t "password_resets.create.email_address_not_found"
      render :new
    end
  end

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, t("password_resets.update.cant_be_empty"))
      render :edit
    elsif @user.update_attributes user_params
      log_in @user
      flash[:success] = t "password_resets.update.password_has_been_reset"
      redirect_to @user
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit :password, :password_confirmation
  end

  def find_user
    @user = User.find_by email: params[:password_reset][:email].downcase
    return unless @user.nil?
    redirect_to root_path
    flash[:danger] = t "users.cant_find_user"
  end

  def check_expiration
    return unless @user.password_reset_expired?
    flash[:danger] = t "password_resets.check_expiration.password_expired"
    redirect_to new_password_reset_url
  end

  def get_user
    @user = User.find_by email: params[:email]
    return unless @user.nil?
    redirect_to root_path
    flash[:danger] = t "users.cant_find_user"
  end

  def valid_user
    unless @user && @user.activated? &&
           @user.authenticated?(:reset, params[:id])
      redirect_to root_url
    end
  end
end
