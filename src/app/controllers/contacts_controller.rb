class ContactsController < ApplicationController
  before_action :logged_in_user, only: [:index, :show, :destroy]
  before_action :admin_user, only: [:index, :show, :destroy]

  def index
    @contacts = Contact.all.paginate(page: params[:page], per_page: 7)
  end

  def show
    @contact = Contact.find(params[:id])
  end

  def create
    @contact = Contact.new(contact_params)
    if @contact.save
      flash[:success] = "問い合わせが成功しました"
      redirect_to root_path
    else
      flash.now[:danger] = "問い合わせが失敗しました"
      render 'static_pages/home'
    end
  end

  def destroy
    Contact.find(params[:id]).destroy
    flash[:success] = "お問い合わせを削除しました"
    redirect_to current_user
  end

  private

  def contact_params
    params.require(:contact).permit(:name, :email, :subject, :text)
  end

  def admin_user
    redirect_to root_path unless current_user.admin?
  end
end
