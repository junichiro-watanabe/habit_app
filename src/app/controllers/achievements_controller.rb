class AchievementsController < ApplicationController
  protect_from_forgery except: [:update, :encourage]
  before_action :logged_in_user
  before_action :belonged_to_group

  def update
    group = Group.find(params[:id])
    current_user.toggle_achieved(group)
    response = current_user.achieving.find_by(belong: current_user.belongs.find_by(group: group))
    render json: response
  end

  def encourage
    @group = Group.find(params[:id])
    @achievement = current_user.achieving.find_by(belong: current_user.belongs.find_by(group: @group))
    @history = History.find_by(achievement: @achievement, date: Date.today)
    content = params[:content]
    if @history
      micropost = @history.microposts.build(user: current_user, content: content, encouragement: true)
      if micropost.save
        flash[:success] = "#{@group.name} のメンバーを煽りました"
        redirect_to @group
      else
        render 'groups/show'
      end
    else
      flash.now[:danger] = "煽るためには本日の目標を達成してください。"
      render 'groups/show'
    end
  end

  private
    def belonged_to_group
      @group = Group.find(params[:id])
      redirect_to groups_path unless current_user.belonging?(@group)
    end

end
