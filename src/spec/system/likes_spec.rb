require 'rails_helper'

RSpec.describe "Likes", type: :system do
  include TestHelper

  before do
    @user = create(:user)
    @group = create(:groups, user: @user)
    @user.belong(@group)
    @user.toggle_achieved(@group)
    @micropost = Micropost.find_by(user: @user)
    1.upto 5 do |n|
      eval("@user_#{n} = create(:users)")
      eval("@user_#{n}.belong(@group)")
      eval("@user_#{n}.toggle_achieved(@group)")
      eval("@user_#{n}.like(@micropost)")
      eval("@micropost_#{n} = Micropost.find_by(user: @user_#{n})")
      eval("@user.like(Micropost.find_by(user: @user_#{n}))") unless n == 5
    end
  end

  describe "いいねのテスト" do
    it "いいね → いいね外し" do
      log_in_as_system(@user)
      visit user_path(@user)
      expect(current_path).to eq user_path(@user)
      feeds = @user.feed
      feeds.each do |feed|
        within "#micropost-#{feed.id}" do
          expect(page).to have_selector ".glyphicon-heart"
          expect(page).to have_link feed.likers.count.to_s, href: like_path(feed)
        end
      end
      within "#micropost-#{@micropost_5.id}" do
        expect(@user.like?(@micropost_5)).to eq false
        expect(page).not_to have_selector ".like"
        expect(page).to have_selector ".unlike"
        expect(page).to have_link @micropost_5.likers.count.to_s, href: like_path(@micropost_5)
        find('.glyphicon-heart').click
        expect(page).to have_selector ".like"
        expect(page).not_to have_selector ".unlike"
        expect(page).to have_link @micropost_5.likers.count.to_s, href: like_path(@micropost_5)
        find('.glyphicon-heart').click
        expect(page).not_to have_selector ".like"
        expect(page).to have_selector ".unlike"
        expect(page).to have_link @micropost_5.likers.count.to_s, href: like_path(@micropost_5)
      end
    end
  end

  describe "いいねしたユーザー一覧のテスト" do
    it "一覧が正常に表示されている" do
      log_in_as_system(@user)
      visit like_path(@micropost)
      expect(current_path).to eq like_path(@micropost)
      users = @micropost.likers
      users.each do |user|
        within "#user-#{user.id}" do
          expect(page).to have_link user.name, href: user_path(user)
          expect(page).to have_content user.introduction
        end
      end
    end

    it "フレンドリーフォロワーディング" do
      visit like_path(@micropost)
      expect(current_path).to eq root_path
      find('.glyphicon-log-in').click
      fill_in "session_email", with: @user.email
      fill_in "session_password", with: "password"
      click_button "ログイン"
      expect(current_path).to eq like_path(@micropost)
      users = @micropost.likers
      users.each do |user|
        within "#user-#{user.id}" do
          expect(page).to have_link user.name, href: user_path(user)
          expect(page).to have_content user.introduction
        end
      end
    end
  end

  describe "いいねした投稿一覧のテスト" do
    it "一覧が正常に表示されている" do
      log_in_as_system(@user)
      visit like_feeds_user_path(@user)
      expect(current_path).to eq like_feeds_user_path(@user)
      microposts = @user.like_feeds
      microposts.each do |micropost|
        expect(page).to have_selector "#micropost-#{micropost.id}"
      end
    end

    it "フレンドリーフォロワーディング" do
      visit like_feeds_user_path(@user)
      expect(current_path).to eq root_path
      find('.glyphicon-log-in').click
      fill_in "session_email", with: @user.email
      fill_in "session_password", with: "password"
      click_button "ログイン"
      expect(current_path).to eq like_feeds_user_path(@user)
      microposts = @user.like_feeds
      microposts.each do |micropost|
        expect(page).to have_selector "#micropost-#{micropost.id}"
      end
    end
  end
end
