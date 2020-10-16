class LikesController < ApplicationController
  def update
    micropost = Micropost.find(params[:id])
    current_user.like(micropost)
    response = {like_count: micropost.likers.count}
    render json: response
  end

  def destroy
    micropost = Micropost.find(params[:id])
    current_user.unlike(micropost)
    response = {like_count: micropost.likers.count}
    render json: response
  end
end
