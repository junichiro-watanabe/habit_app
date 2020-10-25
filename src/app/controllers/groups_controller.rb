class GroupsController < ApplicationController
  before_action :logged_in_user
  before_action :owner_user, only: [:edit, :edit_image, :update, :delete, :destroy]

  def index
    @title = "コミュニティ一覧"
    @heading = "コミュニティを探す"
    @controller = :groups
    @action = :index
    if params[:groups].nil?
      @groups = Group.paginate(page: params[:page], per_page: 7)
    else
      keyword = params[:groups][:search]
      @groups = Group.where("concat(name, habit, overview) LIKE :keyword", keyword: "%#{keyword}%").paginate(page: params[:page], per_page: 7)
    end
    render 'shared/group_index'
  end

  def new
    @group = Group.new
  end

  def create
    @group = current_user.groups.build(group_params)
    if @group.save
      current_user.belong(@group)
      flash[:success] = "コミュニティ作成が完了しました。"
      redirect_to @group
    else
      render 'new'
    end
  end

  def show
    @group = Group.find(params[:id])
    @feed_items = @group.feed.paginate(page: params[:page], per_page: 7)
  end

  def edit
    @group = Group.find(params[:id])
  end

  def edit_image
    @group = Group.find(params[:id])
  end

  def update
    @group = Group.find(params[:id])
    if params[:edit_element] == "group"
      if @group.update(group_params)
        flash[:success] = "グループ編集が完了しました"
        redirect_to @group
      else
        @edit_element = "group"
        render 'edit'
      end
    elsif params[:edit_element] == "image" && !params[:group].nil?
      @group.image.attach(params[:group][:image])
      if @group.save
        flash[:success] = "グループ画像を変更しました"
        redirect_to @group
      else
        @edit_element = "image"
        render 'edit'
      end
    elsif params[:edit_element] == "image" && params[:group].nil?
      @group.image.purge
      if @group.save
        flash[:success] = "グループ画像を削除しました"
        redirect_to @group
      else
        @edit_element = "image"
        render 'edit'
      end
    end
  end

  def delete
    @group = Group.find(params[:id])
  end

  def destroy
    Group.find(params[:id]).destroy
    flash[:success] = "コミュニティを削除しました"
    redirect_to groups_path
  end

  def member
    @group = Group.find(params[:id])
    @title = "メンバー"
    @heading = "#{@group.name} の メンバー"
    @controller = :groups
    @action = :member
    if params[:groups].nil?
      @users = @group.members.paginate(page: params[:page], per_page: 7)
    else
      keyword = params[:groups][:search]
      @users = @group.members.where("concat(name, introduction) LIKE :keyword", keyword: "%#{keyword}%").paginate(page: params[:page], per_page: 7)
    end
    render 'shared/user_index'
  end

  private

  def group_params
    params.require(:group).permit(:name, :habit, :overview)
  end

  def owner_user
    @group = Group.find(params[:id])
    redirect_to groups_path unless @group.owner?(current_user) || current_user.admin?
  end
end
