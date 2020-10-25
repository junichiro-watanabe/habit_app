class ApplicationController < ActionController::Base
  include SessionsHelper

  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "ログインしてください"
      redirect_to root_path
    end
  end

  def redirect_to_user
    redirect_to current_user if logged_in?
  end
end
