require 'rails_helper'

RSpec.describe "MicropostsTimelines", type: :system do
  include TestHelper

  before do
    @user = create(:user)
    @other_user = create(:other_user)
    1.upto 2 do |n|
      eval("@group_#{n} = create(:groups, user: @user)")
    end
    @user.belong(@group_1)
    @user.belong(@group_2)
    @other_user.belong(@group_1)
    @user.toggle_achieved(@group_1)
    @user.toggle_achieved(@group_2)
    @other_user.toggle_achieved(@group_1)
    log_in_as(@user)
    post encourage_achievement_path(@group_1), params: {content: "user_group_1_content"}
    post encourage_achievement_path(@group_2), params: {content: "user_group_2_content"}
    log_in_as(@other_user)
    post encourage_achievement_path(@group_1), params: {content: "other_user_group_1_content"}
  end

  describe "マイページのタイムラインのテスト" do
    it "達成報告/煽りが正常に表示されている" do
      log_in_as_system(@user)
      visit user_path(@user)
      expect(current_path).to eq user_path(@user)
      expect(page).to have_link @user.name, href: user_path(@user)
      expect(page).to have_link @other_user.name, href: user_path(@other_user)
      expect(page).to have_link @group_1.name, href: group_path(@group_1)
      expect(page).to have_content "#{Date.today} 分の #{@group_1.name} の目標を達成しました。"
      expect(page).to have_link @group_2.name, href: group_path(@group_2)
      expect(page).to have_content "#{Date.today} 分の #{@group_2.name} の目標を達成しました。"
      expect(page).to have_content "#{@group_1.name} の #{@user.name} が煽っています"
      expect(page).to have_content "#{@group_2.name} の #{@user.name} が煽っています"
      expect(page).to have_content "#{@group_1.name} の #{@other_user.name} が煽っています"
    end

    it "本日分の煽られた数がマイページに表示されている → 煽られた一覧が正常に表示されている → 次の日にはリセット" do
      log_in_as_system(@user)
      visit user_path(@user)
      expect(current_path).to eq user_path(@user)
      expect(page).to have_link @user.encouraged_feed.count.to_s, href: encouraged_user_path(@user)
      click_link @user.encouraged_feed.count.to_s
      feeds = @user.encouraged_feed
      feeds.each do |feed|
        expect(page).to have_content feed.content
      end
      travel_to(Date.tomorrow) do
        visit user_path(@user)
        expect(current_path).to eq user_path(@user)
        expect(page).not_to have_link @user.encouraged_feed.count.to_s, href: encouraged_user_path(@user)
      end
    end

    it "フレンドリーフォロワーディング" do
      visit user_path(@user)
      expect(current_path).to eq login_path
      fill_in "session_email", with: @user.email
      fill_in "session_password", with: "password"
      click_button "ログイン"
      expect(current_path).to eq user_path(@user)
      expect(page).to have_link @user.name, href: user_path(@user)
      expect(page).to have_link @other_user.name, href: user_path(@other_user)
      expect(page).to have_link @group_1.name, href: group_path(@group_1)
      expect(page).to have_content "#{Date.today} 分の #{@group_1.name} の目標を達成しました。"
      expect(page).to have_link @group_2.name, href: group_path(@group_2)
      expect(page).to have_content "#{Date.today} 分の #{@group_2.name} の目標を達成しました。"
      expect(page).to have_content "#{@group_1.name} の #{@user.name} が煽っています"
      expect(page).to have_content "#{@group_2.name} の #{@user.name} が煽っています"
      expect(page).to have_content "#{@group_1.name} の #{@other_user.name} が煽っています"
    end
  end

  describe "ユーザ照会画面のタイムラインのテスト" do
    it "達成報告/煽りが正常に表示されている" do
      log_in_as_system(@user)
      visit user_path(@other_user)
      expect(current_path).to eq user_path(@other_user)
      expect(page).not_to have_link @user.name, href: user_path(@user)
      expect(page).to have_link @other_user.name, href: user_path(@other_user)
      expect(page).to have_link @group_1.name, href: group_path(@group_1)
      expect(page).to have_content "#{Date.today} 分の #{@group_1.name} の目標を達成しました。"
      expect(page).not_to have_link @group_2.name, href: group_path(@group_2)
      expect(page).not_to have_content "#{Date.today} 分の #{@group_2.name} の目標を達成しました。"
      expect(page).not_to have_content "#{@group_1.name} の #{@user.name} が煽っています"
      expect(page).not_to have_content "#{@group_2.name} の #{@user.name} が煽っています"
      expect(page).to have_content "#{@group_1.name} の #{@other_user.name} が煽っています"
    end

    it "フレンドリーフォロワーディング" do
      visit user_path(@other_user)
      expect(current_path).to eq login_path
      fill_in "session_email", with: @user.email
      fill_in "session_password", with: "password"
      click_button "ログイン"
      expect(current_path).to eq user_path(@other_user)
      expect(page).not_to have_link @user.name, href: user_path(@user)
      expect(page).to have_link @other_user.name, href: user_path(@other_user)
      expect(page).to have_link @group_1.name, href: group_path(@group_1)
      expect(page).to have_content "#{Date.today} 分の #{@group_1.name} の目標を達成しました。"
      expect(page).not_to have_link @group_2.name, href: group_path(@group_2)
      expect(page).not_to have_content "#{Date.today} 分の #{@group_2.name} の目標を達成しました。"
      expect(page).not_to have_content "#{@group_1.name} の #{@user.name} が煽っています"
      expect(page).not_to have_content "#{@group_2.name} の #{@user.name} が煽っています"
      expect(page).to have_content "#{@group_1.name} の #{@other_user.name} が煽っています"
    end
  end

  describe "グループ紹介画面のタイムラインのテスト" do
    it "達成報告/煽りが正常に表示されている" do
      log_in_as_system(@user)
      visit group_path(@group_1)
      expect(current_path).to eq group_path(@group_1)
      expect(page).to have_link @user.name, href: user_path(@user)
      expect(page).to have_link @other_user.name, href: user_path(@other_user)
      expect(page).to have_link @group_1.name, href: group_path(@group_1)
      expect(page).to have_content "#{Date.today} 分の #{@group_1.name} の目標を達成しました。"
      expect(page).not_to have_link @group_2.name, href: group_path(@group_2)
      expect(page).not_to have_content "#{Date.today} 分の #{@group_2.name} の目標を達成しました。"
      expect(page).to have_content "#{@group_1.name} の #{@user.name} が煽っています"
      expect(page).not_to have_content "#{@group_2.name} の #{@user.name} が煽っています"
      expect(page).to have_content "#{@group_1.name} の #{@other_user.name} が煽っています"
    end

    it "フレンドリーフォロワーディング" do
      visit group_path(@group_1)
      expect(current_path).to eq login_path
      fill_in "session_email", with: @user.email
      fill_in "session_password", with: "password"
      click_button "ログイン"
      expect(current_path).to eq group_path(@group_1)
      expect(page).to have_link @user.name, href: user_path(@user)
      expect(page).to have_link @other_user.name, href: user_path(@other_user)
      expect(page).to have_link @group_1.name, href: group_path(@group_1)
      expect(page).to have_content "#{Date.today} 分の #{@group_1.name} の目標を達成しました。"
      expect(page).not_to have_link @group_2.name, href: group_path(@group_2)
      expect(page).not_to have_content "#{Date.today} 分の #{@group_2.name} の目標を達成しました。"
      expect(page).to have_content "#{@group_1.name} の #{@user.name} が煽っています"
      expect(page).not_to have_content "#{@group_2.name} の #{@user.name} が煽っています"
      expect(page).to have_content "#{@group_1.name} の #{@other_user.name} が煽っています"
    end
  end

end
