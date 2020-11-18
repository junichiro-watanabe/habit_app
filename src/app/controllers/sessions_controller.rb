class SessionsController < ApplicationController
  def create
    @user = User.find_by(email: params[:session][:email])
    if @user&.authenticate(params[:session][:password])
      log_in @user
      redirect_back_or @user
    else
      flash.now[:danger] = "ログイン情報が正しくありません"
      render 'static_pages/home'
    end
  end

  def destroy
    log_out
    redirect_to root_path
  end

  def create_guest
    @user = User.find_by(email: "guest@example.com")
    log_in @user
    if @user.encouraged.count.zero?
      [{ user: 3, group: 7, content: "本日の私のタスクは完了しました！みなさんも頑張ってくださいね(^^)" },
       { user: 4, group: 4, content: "本日もたくさんの学びがありました。みなさんも学びましょう！" },
       { user: 5, group: 9, content: "10分も勉強していないってマ？" }].each do |item|
        user = User.find(item[:user])
        group = Group.find(item[:group])
        user.not_achieved
        user.toggle_achieved(group)
        achievement = user.achieving.find_by(belong: user.belongs.find_by(group: group))
        history = History.find_by(achievement: achievement, date: Date.today)
        history.microposts.create(user: user, content: item[:content], encouragement: true)
      end
    end
    redirect_back_or @user
  end
end
