class RelationshipsController < ApplicationController
  before_action :logged_in_user

  def update
    user = User.find(params[:id])
    current_user.follow(user) unless current_user == user
    response = { follow: current_user.following?(user),
                 active_following_count: current_user.following.count,
                 active_followers_count: current_user.followers.count,
                 passive_following_count: user.following.count,
                 passive_followers_count: user.followers.count }
    render json: response
  end

  def destroy
    user = User.find(params[:id])
    current_user.unfollow(user)
    response = { follow: current_user.following?(user),
                 active_following_count: current_user.following.count,
                 active_followers_count: current_user.followers.count,
                 passive_following_count: user.following.count,
                 passive_followers_count: user.followers.count }
    render json: response
  end
end
