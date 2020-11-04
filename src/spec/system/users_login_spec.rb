require 'rails_helper'

RSpec.describe "UsersLogin", type: :system do
  before do
    @user = create(:user)
  end

  describe "ログインのテスト" do
    it "ログイン成功 → ヘッダーリンクが変更される → ログアウト → 2回目ログアウト" do
      visit root_path
      find('.glyphicon-log-in').click
      fill_in "session_email", with: @user.email
      fill_in "session_password", with: "password"
      click_button "ログイン"
      expect(page).not_to have_link "ホーム", href: root_path
      expect(page).not_to have_content "ログイン"
      expect(page).not_to have_link "新規登録", href: signup_path
      expect(page).to have_link "ホーム", href: user_path(@user)
      expect(page).to have_link "コミュニティ", href: "#"
      within ".user" do
        find("img").click
      end
      click_link "ログアウト"
      expect(page).to have_link "ホーム", href: root_path
      expect(page).to have_content "ログイン"
      expect(page).to have_link "新規登録", href: signup_path
      expect(page).not_to have_link "ホーム", href: user_path(@user)
      expect(page).not_to have_link "コミュニティ", href: "#"
      expect(page).not_to have_selector ".user"
      delete login_path
      visit root_path
      expect(page).to have_link "ホーム", href: root_path
      expect(page).to have_content "ログイン"
      expect(page).to have_link "新規登録", href: signup_path
      expect(page).not_to have_link "ホーム", href: user_path(@user)
      expect(page).not_to have_link "コミュニティ", href: "#"
      expect(page).not_to have_selector ".user"
    end

    it "ログイン失敗 + ホーム画面に遷移したらエラーメッセージが表示されない" do
      visit root_path
      find('.glyphicon-log-in').click
      fill_in "session_email", with: @user.email
      fill_in "session_password", with: "invalid_password"
      click_button "ログイン"
      expect(page).to have_selector '.alert-danger'
      visit root_path
      expect(page).not_to have_selector '.alert-danger'
    end
  end
end
