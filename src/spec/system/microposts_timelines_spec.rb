require 'rails_helper'

RSpec.describe "MicropostsTimelines", type: :system do
  include TestHelper

  before do
    @user = create(:user)
    @other_user = create(:other_user)
    @other_user2 = create(:users)
    @admin = create(:admin)
    1.upto 3 do |n|
      eval("@group_#{n} = create(:groups, user: @user)")
    end
    @user.belong(@group_1)
    @other_user.belong(@group_1)
    @other_user.belong(@group_2)
    @other_user2.belong(@group_3)
    @user.toggle_achieved(@group_1)
    @other_user.toggle_achieved(@group_1)
    @other_user.toggle_achieved(@group_2)
    @other_user2.toggle_achieved(@group_3)
    @user.follow(@other_user2)
    log_in_as(@user)
    post encourage_achievement_path(@group_1), params: { content: "user_group_1_content" }
    log_in_as(@other_user)
    post encourage_achievement_path(@group_1), params: { content: "other_user_group_1_content" }
    post encourage_achievement_path(@group_2), params: { content: "other_user_group_2_content" }
    log_in_as(@other_user2)
    post encourage_achievement_path(@group_3), params: { content: "other_user_2_group_3_content" }
  end

  describe "マイページのタイムラインのテスト" do
    it "達成報告/煽りが正常に表示されている" do
      log_in_as_system(@user)
      visit user_path(@user)
      expect(current_path).to eq user_path(@user)
      expect(page).to have_link @user.name, href: user_path(@user)
      expect(page).to have_link @other_user.name, href: user_path(@other_user)
      expect(page).to have_link @other_user2.name, href: user_path(@other_user2)
      expect(page).to have_link @group_1.name, href: group_path(@group_1)
      expect(page).to have_content "#{Date.today} 分の #{@group_1.name} の目標を達成しました。"
      expect(page).not_to have_link @group_2.name, href: group_path(@group_2)
      expect(page).not_to have_content "#{Date.today} 分の #{@group_2.name} の目標を達成しました。"
      expect(page).to have_link @group_3.name, href: group_path(@group_3)
      expect(page).to have_content "#{Date.today} 分の #{@group_3.name} の目標を達成しました。"
      expect(page).to have_content "#{@group_1.name} の #{@user.name} さんが煽っています"
      expect(page).to have_content "#{@group_1.name} の #{@other_user.name} さんが煽っています"
      expect(page).not_to have_content "#{@group_2.name} の #{@other_user.name} さんが煽っています"
      expect(page).to have_content "#{@group_3.name} の #{@other_user2.name} さんが煽っています"
    end

    it "本日分の煽られた数がマイページに表示されている → 煽られた一覧が正常に表示されている → 次の日にはリセット" do
      log_in_as_system(@user)
      visit user_path(@user)
      expect(current_path).to eq user_path(@user)
      expect(page).to have_content "#{@user.encouraged.count} 回煽られています"
      find("#encouraged").click
      feeds = @user.encouraged
      feeds.each do |feed|
        expect(page).to have_content feed[:content]
      end
      travel_to(Date.tomorrow) do
        visit user_path(@user)
        expect(current_path).to eq user_path(@user)
        expect(page).not_to have_content "#{@user.encouraged.count} 回煽られています"
      end
    end

    it "フレンドリーフォロワーディング" do
      visit user_path(@user)
      expect(current_path).to eq root_path
      find('.glyphicon-log-in').click
      fill_in "session_email", with: @user.email
      fill_in "session_password", with: "password"
      click_button "ログイン"
      expect(current_path).to eq user_path(@user)
      expect(page).to have_link @user.name, href: user_path(@user)
      expect(page).to have_link @other_user.name, href: user_path(@other_user)
      expect(page).to have_link @other_user2.name, href: user_path(@other_user2)
      expect(page).to have_link @group_1.name, href: group_path(@group_1)
      expect(page).to have_content "#{Date.today} 分の #{@group_1.name} の目標を達成しました。"
      expect(page).not_to have_link @group_2.name, href: group_path(@group_2)
      expect(page).not_to have_content "#{Date.today} 分の #{@group_2.name} の目標を達成しました。"
      expect(page).to have_link @group_3.name, href: group_path(@group_3)
      expect(page).to have_content "#{Date.today} 分の #{@group_3.name} の目標を達成しました。"
      expect(page).to have_content "#{@group_1.name} の #{@user.name} さんが煽っています"
      expect(page).to have_content "#{@group_1.name} の #{@other_user.name} さんが煽っています"
      expect(page).not_to have_content "#{@group_2.name} の #{@other_user.name} さんが煽っています"
      expect(page).to have_content "#{@group_3.name} の #{@other_user2.name} さんが煽っています"
    end
  end

  describe "ユーザ紹介画面のタイムラインのテスト" do
    it "達成報告/煽りが正常に表示されている" do
      log_in_as_system(@user)
      visit user_path(@other_user)
      expect(current_path).to eq user_path(@other_user)
      expect(page).not_to have_link @user.name, href: user_path(@user)
      expect(page).to have_link @other_user.name, href: user_path(@other_user)
      expect(page).not_to have_link @other_user2.name, href: user_path(@other_user2)
      expect(page).to have_link @group_1.name, href: group_path(@group_1)
      expect(page).to have_content "#{Date.today} 分の #{@group_1.name} の目標を達成しました。"
      expect(page).to have_link @group_2.name, href: group_path(@group_2)
      expect(page).to have_content "#{Date.today} 分の #{@group_2.name} の目標を達成しました。"
      expect(page).not_to have_link @group_3.name, href: group_path(@group_3)
      expect(page).not_to have_content "#{Date.today} 分の #{@group_3.name} の目標を達成しました。"
      expect(page).not_to have_content "#{@group_1.name} の #{@user.name} さんが煽っています"
      expect(page).to have_content "#{@group_1.name} の #{@other_user.name} さんが煽っています"
      expect(page).to have_content "#{@group_2.name} の #{@other_user.name} さんが煽っています"
      expect(page).not_to have_content "#{@group_3.name} の #{@other_user2.name} さんが煽っています"
    end

    it "フレンドリーフォロワーディング" do
      visit user_path(@other_user)
      expect(current_path).to eq root_path
      find('.glyphicon-log-in').click
      fill_in "session_email", with: @user.email
      fill_in "session_password", with: "password"
      click_button "ログイン"
      expect(current_path).to eq user_path(@other_user)
      expect(page).not_to have_link @user.name, href: user_path(@user)
      expect(page).to have_link @other_user.name, href: user_path(@other_user)
      expect(page).not_to have_link @other_user2.name, href: user_path(@other_user2)
      expect(page).to have_link @group_1.name, href: group_path(@group_1)
      expect(page).to have_content "#{Date.today} 分の #{@group_1.name} の目標を達成しました。"
      expect(page).to have_link @group_2.name, href: group_path(@group_2)
      expect(page).to have_content "#{Date.today} 分の #{@group_2.name} の目標を達成しました。"
      expect(page).not_to have_link @group_3.name, href: group_path(@group_3)
      expect(page).not_to have_content "#{Date.today} 分の #{@group_3.name} の目標を達成しました。"
      expect(page).not_to have_content "#{@group_1.name} の #{@user.name} さんが煽っています"
      expect(page).to have_content "#{@group_1.name} の #{@other_user.name} さんが煽っています"
      expect(page).to have_content "#{@group_2.name} の #{@other_user.name} さんが煽っています"
      expect(page).not_to have_content "#{@group_3.name} の #{@other_user2.name} さんが煽っています"
    end
  end

  describe "グループ紹介画面のタイムラインのテスト" do
    it "達成報告/煽りが正常に表示されている" do
      log_in_as_system(@user)
      visit group_path(@group_1)
      expect(current_path).to eq group_path(@group_1)
      expect(page).to have_link @user.name, href: user_path(@user)
      expect(page).to have_link @other_user.name, href: user_path(@other_user)
      expect(page).not_to have_link @other_user2.name, href: user_path(@other_user2)
      expect(page).to have_link @group_1.name, href: group_path(@group_1)
      expect(page).to have_content "#{Date.today} 分の #{@group_1.name} の目標を達成しました。"
      expect(page).not_to have_link @group_2.name, href: group_path(@group_2)
      expect(page).not_to have_content "#{Date.today} 分の #{@group_2.name} の目標を達成しました。"
      expect(page).not_to have_link @group_3.name, href: group_path(@group_3)
      expect(page).not_to have_content "#{Date.today} 分の #{@group_3.name} の目標を達成しました。"
      expect(page).to have_content "#{@group_1.name} の #{@user.name} さんが煽っています"
      expect(page).to have_content "#{@group_1.name} の #{@other_user.name} さんが煽っています"
      expect(page).not_to have_content "#{@group_2.name} の #{@other_user.name} さんが煽っています"
      expect(page).not_to have_content "#{@group_3.name} の #{@other_user2.name} さんが煽っています"
    end

    it "フレンドリーフォロワーディング" do
      visit group_path(@group_1)
      expect(current_path).to eq root_path
      find('.glyphicon-log-in').click
      fill_in "session_email", with: @user.email
      fill_in "session_password", with: "password"
      click_button "ログイン"
      expect(current_path).to eq group_path(@group_1)
      expect(current_path).to eq group_path(@group_1)
      expect(page).to have_link @user.name, href: user_path(@user)
      expect(page).to have_link @other_user.name, href: user_path(@other_user)
      expect(page).not_to have_link @other_user2.name, href: user_path(@other_user2)
      expect(page).to have_link @group_1.name, href: group_path(@group_1)
      expect(page).to have_content "#{Date.today} 分の #{@group_1.name} の目標を達成しました。"
      expect(page).not_to have_link @group_2.name, href: group_path(@group_2)
      expect(page).not_to have_content "#{Date.today} 分の #{@group_2.name} の目標を達成しました。"
      expect(page).not_to have_link @group_3.name, href: group_path(@group_3)
      expect(page).not_to have_content "#{Date.today} 分の #{@group_3.name} の目標を達成しました。"
      expect(page).to have_content "#{@group_1.name} の #{@user.name} さんが煽っています"
      expect(page).to have_content "#{@group_1.name} の #{@other_user.name} さんが煽っています"
      expect(page).not_to have_content "#{@group_2.name} の #{@other_user.name} さんが煽っています"
      expect(page).not_to have_content "#{@group_3.name} の #{@other_user2.name} さんが煽っています"
    end
  end

  describe "投稿削除のテスト" do
    it "投稿削除ボタンが表示される → 投稿削除" do
      log_in_as_system(@user)
      visit user_path(@user)
      micropost = Micropost.find_by(user: @user)
      within "#micropost-#{micropost.id}" do
        find(".glyphicon-remove-circle").click
      end
      expect(current_path).to eq user_path(@user)
      expect(page).not_to have_selector "#micropost-#{micropost.id}"
    end

    it "投稿削除削除ボタンが表示されない：違うユーザ" do
      log_in_as_system(@user)
      visit user_path(@other_user)
      micropost = Micropost.find_by(user: @other_user)
      within "#micropost-#{micropost.id}" do
        expect(page).not_to have_selector ".glyphicon-remove-circle"
      end
    end

    it "投稿削除ボタンが表示される → 投稿削除：管理者ユーザ" do
      log_in_as_system(@admin)
      visit user_path(@user)
      micropost = Micropost.find_by(user: @user)
      within "#micropost-#{micropost.id}" do
        find(".glyphicon-remove-circle").click
      end
      expect(current_path).to eq user_path(@admin)
      visit user_path(@user)
      expect(page).not_to have_selector "#micropost-#{micropost.id}"
    end
  end
end
