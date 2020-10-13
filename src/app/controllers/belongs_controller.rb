class BelongsController < ApplicationController
  before_action :logged_in_user

  def update
    group = Group.find(params[:id])
    current_user.belong(group)
    response = Belong.where(user: current_user).find_by(group: group)
    response = response.attributes
    response.store("member_count", group.members.count)
    response.store("achieved", current_user.achieved?(group))
    render json: response
  end

  def destroy
    group = Group.find(params[:id])
    current_user.leave(group)
    response = {member_count: group.members.count, achieved: false}
    render json: response
  end
end
