class LikesController < ApplicationController
  before_action :logged_in_user, only: [:show, :update, :destroy]

  def show
    @feed_items = Micropost.where(id: params[:id])
    @users = @feed_items[0].likers.paginate(page: params[:page], per_page: 7)
  end

  def update
    micropost = Micropost.find(params[:id])
    current_user.like(micropost) unless current_user?(micropost.user)
    response = { like: current_user.like?(micropost), like_count: micropost.likers.count }
    render json: response
  end

  def destroy
    micropost = Micropost.find(params[:id])
    current_user.unlike(micropost)
    response = { like: current_user.like?(micropost), like_count: micropost.likers.count }
    render json: response
  end
end
