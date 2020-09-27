class AchievementsController < ApplicationController
  protect_from_forgery except: [:update]
  before_action :logged_in_user
  before_action :belonged_to_group

  def update
    @group = Group.find(params[:id])
    current_user.toggle_achieved(@group)
    @response = current_user.achieving.find_by(belong: current_user.belongs.find_by(group: @group))
    render json: @response
  end

  private
    def belonged_to_group
      @group = Group.find(params[:id])
      redirect_to groups_path unless current_user.belonging?(@group)
    end

end
