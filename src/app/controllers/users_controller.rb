class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :show, :edit, :edit_image, :update, :delete, :destroy, :owning, :belonging]
  before_action :correct_user, only: [:edit, :edit_image, :update, :delete, :destroy]

  def index
    @users = User.paginate(page: params[:page], per_page: 7)
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
      @feed_items = Micropost.where(user: @user).paginate(page: params[:page], per_page: 7)
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
    @title = "主催コミュニティ"
    @user = User.find(params[:id])
    @groups = @user.groups.paginate(page: params[:page], per_page: 7)
  end

  def belonging
    @title = "参加コミュニティ"
    @user = User.find(params[:id])
    @groups = @user.belonging.paginate(page: params[:page], per_page: 7)
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to root_path unless current_user?(@user)
    end

end
