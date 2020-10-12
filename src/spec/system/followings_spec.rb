require 'rails_helper'

RSpec.describe "Followings", type: :system do
  include TestHelper

  before do
    @user = create(:user)
    1.upto 10 do |n|
      eval("@user_#{n} = create(:users)")
      eval("@user_#{n}.follow(@user)")
    end
    2.upto 10 do |n|
      eval("@user.follow(@user_#{n})")
    end
  end

  describe "フォロー/アンフォローのテスト" do
    it "フォロー → アンフォロー：ユーザ紹介画面から" do

    end

    it "フォロー → アンフォロー：ユーザ一覧から" do

    end
  end

  describe "フォロー一覧のテスト" do
    it "一覧が正常に表示されている" do
      log_in_as_system(@user)
      visit following_user_path(@user)
      expect(current_path).to eq following_user_path(@user)
      users = @user.following.paginate(page: 1, per_page: 7)
      users.each do |user|
        expect(page).to have_link user.name, href: user_path(user)
        expect(page).to have_content user.introduction
      end
    end

    it "フレンドリーフォロワーディング" do
      visit following_user_path(@user)
      expect(current_path).to eq login_path
      fill_in "session_email", with: @user.email
      fill_in "session_password", with: "password"
      click_button "ログイン"
      expect(current_path).to eq following_user_path(@user)
      users = @user.following.paginate(page: 1, per_page: 7)
      users.each do |user|
        expect(page).to have_link user.name, href: user_path(user)
        expect(page).to have_content user.introduction
      end
    end
  end

  describe "フォロワー一覧のテスト" do
    it "一覧が正常に表示されている" do
      log_in_as_system(@user)
      visit followers_user_path(@user)
      expect(current_path).to eq followers_user_path(@user)
      users = @user.followers.paginate(page: 1, per_page: 7)
      users.each do |user|
        expect(page).to have_link user.name, href: user_path(user)
        expect(page).to have_content user.introduction
      end
    end

    it "フレンドリーフォロワーディング" do
      visit followers_user_path(@user)
      expect(current_path).to eq login_path
      fill_in "session_email", with: @user.email
      fill_in "session_password", with: "password"
      click_button "ログイン"
      expect(current_path).to eq followers_user_path(@user)
      users = @user.followers.paginate(page: 1, per_page: 7)
      users.each do |user|
        expect(page).to have_link user.name, href: user_path(user)
        expect(page).to have_content user.introduction
      end
    end
  end
end
