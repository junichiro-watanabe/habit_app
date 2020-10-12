class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :show, :edit, :edit_image, :update, :delete, :destroy, :owning, :belonging, :not_achieved, :encouraged, :following, :followers]
  before_action :correct_user, only: [:edit, :edit_image, :update, :delete, :destroy]

  def index
    @users = User.paginate(page: params[:page], per_page: 7)
    @title = "ユーザ一覧"
    @heading = "仲間を探す"
    @controller = :users
    @action = :index
    if params[:users] == nil
      @users = User.paginate(page: params[:page], per_page: 7)
    else
      keyword = params[:users][:search]
      @users = User.where("concat(name, introduction) LIKE :keyword", keyword: "%#{keyword}%").paginate(page: params[:page], per_page: 7)
    end
    render 'shared/user_index'
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "ユーザ登録が完了しました。"
      log_in @user
      redirect_to @user
    else
      render 'new'
    end
  end

  def show
    @user = User.find(params[:id])
    if current_user?(@user)
      @feed_items = @user.feed.paginate(page: params[:page], per_page: 7)
    else
      @feed_items = Micropost.where(user: @user).paginate(page: params[:page], per_page: 7).order("created_at DESC")
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def edit_image
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if params[:edit_element] == "profile"
      if @user.update(user_params)
        flash[:success] = "プロフィール編集が完了しました"
        redirect_to @user
      else
        @edit_element = "profile"
        render 'edit'
      end
    elsif params[:edit_element] == "image" && !params[:user].nil?
      @user.image.attach(params[:user][:image])
      if @user.save
        flash[:success] = "プロフィール画像を変更しました"
        redirect_to @user
      else
        @edit_element = "image"
        render 'edit'
      end
    elsif params[:edit_element] == "image" && params[:user].nil?
      @user.image.purge
      if @user.save
        flash[:success] = "プロフィール画像を削除しました"
        redirect_to @user
      else
        @edit_element = "image"
        render 'edit'
      end
    end
  end

  def delete
    @user = User.find(params[:id])
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "アカウントを閉鎖しました"
    log_out
    redirect_to root_path
  end

  def owning
    @user = User.find(params[:id])
    @title = "主催コミュニティ"
    @heading = "#{@user.name} の #{@title}"
    @controller = :users
    @action = :owning
    if params[:users] == nil
      @groups = @user.groups.paginate(page: params[:page], per_page: 7)
    else
      keyword = params[:users][:search]
      @groups = @user.groups.where("concat(name, habit, overview) LIKE :keyword", keyword: "%#{keyword}%").paginate(page: params[:page], per_page: 7)
    end
    render 'shared/group_index'
  end

  def belonging
    @user = User.find(params[:id])
    @title = "参加コミュニティ"
    @heading = "#{@user.name} の #{@title}"
    @controller = :users
    @action = :belonging
    if params[:users] == nil
      @groups = @user.belonging.paginate(page: params[:page], per_page: 7)
    else
      keyword = params[:users][:search]
      @groups = @user.belonging.where("concat(name, habit, overview) LIKE :keyword", keyword: "%#{keyword}%").paginate(page: params[:page], per_page: 7)
    end
    render 'shared/group_index'
  end

  def not_achieved
    @user = User.find(params[:id])
    @title = "目標未達コミュニティ"
    @heading = "#{@user.name} の #{@title}"
    @controller = :users
    @action = :not_achieved
    if params[:users] == nil
      @groups = @user.not_achieved.paginate(page: params[:page], per_page: 7)
    else
      keyword = params[:users][:search]
      @groups = @user.not_achieved.where("concat(name, habit, overview) LIKE :keyword", keyword: "%#{keyword}%").paginate(page: params[:page], per_page: 7)
    end
    render 'shared/group_index'
  end

  def encouraged
    @user = User.find(params[:id])
    @feed_items = @user.encouraged_feed.paginate(page: params[:page], per_page: 7)
    render 'show'
  end

  def following
    @user = User.find(params[:id])
    @title = "フォロー 一覧"
    @heading = "#{@user.name} の #{@title}"
    @controller = :users
    @action = :following
    if params[:users] == nil
      @users = @user.following.paginate(page: params[:page], per_page: 7)
    else
      keyword = params[:users][:search]
      @users = @user.following.paginate(page: params[:page], per_page: 7).where("concat(name, introduction) LIKE :keyword", keyword: "%#{keyword}%").paginate(page: params[:page], per_page: 7)
    end
    if current_user?(@user)
      render 'follow'
    else
      render 'shared/user_index'
    end
  end

  def followers
    @user = User.find(params[:id])
    @title = "フォロワーー 一覧"
    @heading = "#{@user.name} の #{@title}"
    @controller = :users
    @action = :followers
    if params[:users] == nil
      @users = @user.followers.paginate(page: params[:page], per_page: 7)
    else
      keyword = params[:users][:search]
      @users = @user.followers.paginate(page: params[:page], per_page: 7).where("concat(name, introduction) LIKE :keyword", keyword: "%#{keyword}%").paginate(page: params[:page], per_page: 7)
    end
    if current_user?(@user)
      render 'follow'
    else
      render 'shared/user_index'
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :introduction, :password, :password_confirmation)
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to root_path unless current_user?(@user)
    end

end
