class BelongsController < ApplicationController
  before_action :logged_in_user

  def update
    @group = Group.find(params[:id])
    current_user.belong(@group)
    redirect_to group_path(@group)
  end

  def destroy
    @group = Group.find(params[:id])
    current_user.leave(@group)
    redirect_to group_path(@group)
  end
end
