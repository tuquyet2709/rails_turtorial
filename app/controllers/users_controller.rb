class UsersController < ApplicationController
  def show
    @user = User.find_by id: params[:id]
    redirect_to signup_path if @user.nil?
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_param
    if @user.save
      flash[:success] = t("sign_up.welcome")
      redirect_to @user
    else
      render :new
    end
  end

  private
  def user_param
    params.require(:user).permit :name, :email, :password,
      :password_confirmation
  end
end
