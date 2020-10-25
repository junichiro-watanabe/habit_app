class MicropostsController < ApplicationController
  before_action :logged_in_user
  before_action :poster_user

  def destroy
    Micropost.find(params[:id]).destroy
    flash[:success] = "投稿を削除しました"
    redirect_to user_path(current_user)
  end

  private

  def poster_user
    @micropost = Micropost.find(params[:id])
    redirect_to root_path unless @micropost.poster?(current_user) || current_user.admin?
  end
end
