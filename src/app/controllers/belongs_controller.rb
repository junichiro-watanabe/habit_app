class BelongsController < ApplicationController
  protect_from_forgery except: [:update, :destroy]
  before_action :logged_in_user

  def update
    @group = Group.find(params[:id])
    current_user.belong(@group)
    @response = Belong.where(user: current_user).where(group: @group)
    render json: @response
  end

  def destroy
    @group = Group.find(params[:id])
    current_user.leave(@group)
    redirect_to groups_path
  end
end
