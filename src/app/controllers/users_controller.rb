class UsersController < ApplicationController
  before_action :logged_in_user, only: [:show, :edit, :edit_image, :update, :destroy]
  before_action :correct_user, only: [:edit, :edit_image, :update, :destroy]

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
  end

  def edit
    @user = User.find(params[:id])
    @edit_element = "profile"
  end

  def edit_image
    @user = User.find(params[:id])
    @edit_element = "image"
    render 'edit'
  end

  def update

  end

  def destroy

  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirm)
    end

    def logged_in_user
      redirect_to root_path unless logged_in?
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to root_path unless @user = current_user
    end

end
