class AchievementsController < ApplicationController
  protect_from_forgery except: [:update]
  before_action :logged_in_user

  def show
    @group = Group.find(params[:id])
    current_user.toggle_achieved(@group)
    @response = current_user.achieving.find_by(belong: current_user.belongs.find_by(group: @group))
    render json: @response
  end

  def update
    @group = Group.find(params[:id])
    current_user.toggle_achieved(@group)
    @response = current_user.achieving.find_by(belong: current_user.belongs.find_by(group: @group))
    render json: @response
  end

end
