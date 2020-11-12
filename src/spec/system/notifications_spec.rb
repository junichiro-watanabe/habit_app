require 'rails_helper'

RSpec.describe "Notifications", type: :system do
  include TestHelper

  before do
    @user = create(:user)
    @other_user = create(:other_user)
    @group = create(:group, user: @user)
    @user.belong(@group)
    @user.toggle_achieved(@group)
    @user_micropost = Micropost.find_by(user: @user)
    @other_user.follow(@user)
    @other_user.belong(@group)
    @other_user.like(@user_micropost)
  end

  describe "お知らせ一覧のテスト" do
    it "お知らせ数が正常に表示されている → 一覧が正常に表示されている → お知らせ数リセット" do
      log_in_as_system(@user)
      visit user_path(@user)
      expect(current_path).to eq user_path(@user)
      within "header" do
        within ".bell" do
          expect(page).to have_content "3"
        end
        find(".bell").click
      end
      notifications = @user.passive_notifications
      notifications.each do |notification|
        if notification.action == "follow"
          expect(page).to have_content("#{notification.visitor.name} が あなたをフォローしました。")
        elsif notification.action == "belong"
          expect(page).to have_content("#{notification.visitor.name} が あなたの主催する #{notification.belong.group.name} に参加しました。")
        elsif notification.action == "like"
          expect(page).to have_content("#{notification.visitor.name} が あなたの投稿をいいねしました。")
        elsif notification.action == "message"
          expect(page).to have_content("#{notification.visitor.name} が あなたに メッセージ を送りました。")
        end
      end
      find("#remove-notification").click
      within "header" do
        within ".bell" do
          expect(page).to have_content "0"
        end
      end
    end
  end
end
