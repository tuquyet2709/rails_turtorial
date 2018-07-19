class RelationshipsController < ApplicationController
  before_action :logged_in_user
  def create
    @user = User.find_by followed_id: params[:followed_id]
    current_user.follow user
    redirect_to user
    respond_to do |format|
      format.html {redirect_to @user}
      format.js
    end
  end

  def destroy
    user = Relationship.find_by(id: params[:id]).followed
    current_user.unfollow user
    redirect_to user
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end
end
