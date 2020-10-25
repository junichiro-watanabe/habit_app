class AchievementsController < ApplicationController
  before_action :logged_in_user
  before_action :belonged_to_group
  before_action :achieved_habit, only: [:encourage]

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
    micropost = @history.microposts.build(user: current_user, content: params[:content], encouragement: true)
    if micropost.save
      flash[:success] = "#{@group.name} のメンバーを煽りました"
      redirect_to @group
    else
      @feed_items = @group.feed.paginate(page: params[:page], per_page: 7)
      flash.now[:danger] = "煽りに失敗しました"
      render 'groups/show'
    end
  end

  private

  def belonged_to_group
    @group = Group.find(params[:id])
    unless current_user.belonging?(@group)
      flash[:danger] = "コミュニティに参加してください"
      redirect_to @group
    end
  end

  def achieved_habit
    @group = Group.find(params[:id])
    unless current_user.achieved?(@group)
      flash[:danger] = "煽るためには本日の目標を達成してください"
      redirect_to @group
    end
  end
end
