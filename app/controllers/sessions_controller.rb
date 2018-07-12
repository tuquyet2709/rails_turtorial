class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user &.authenticate params[:session][:password]
      login user
      redirect_to user
    else
      flash.now[:danger] = t(".invalid_message")
      render :new
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end
end
