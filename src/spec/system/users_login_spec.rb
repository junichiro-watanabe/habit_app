require 'rails_helper'

RSpec.describe "UsersLogin", type: :system do

  before do
    @user = create(:user)
  end

  describe "ログインのテスト" do
    it "ログイン成功 → ヘッダーリンクが変更される → ログアウト → 2回目ログアウト" do
      visit login_path
      fill_in "session_email", with: @user.email
      fill_in "session_password", with: "password"
      click_button "ログイン"
      expect(page).not_to have_link "ホーム", href: root_path
      expect(page).not_to have_link "ログイン", href: login_path
      expect(page).not_to have_link "新規登録", href: signup_path
      expect(page).to have_link "マイページ", href: user_path(@user)
      expect(page).to have_link "プロフィール", href: edit_user_path(@user)
      expect(page).to have_link "ログアウト", href: login_path
      click_link "ログアウト"
      expect(page).to have_link "ホーム", href: root_path
      expect(page).to have_link "ログイン", href: login_path
      expect(page).to have_link "新規登録", href: signup_path
      expect(page).not_to have_link "マイページ", href: user_path(@user)
      expect(page).not_to have_link "プロフィール", href: edit_user_path(@user)
      expect(page).not_to have_link "ログアウト", href: login_path
      delete login_path
      visit root_path
      expect(page).to have_link "ホーム", href: root_path
      expect(page).to have_link "ログイン", href: login_path
      expect(page).to have_link "新規登録", href: signup_path
      expect(page).not_to have_link "マイページ", href: user_path(@user)
      expect(page).not_to have_link "プロフィール", href: edit_user_path(@user)
      expect(page).not_to have_link "ログアウト", href: login_path
    end

    it "ログイン失敗 + ホーム画面に遷移したらエラーメッセージが表示されない" do
      visit login_path
      fill_in "session_email", with: @user.email
      fill_in "session_password", with: "invalid_password"
      click_button "ログイン"
      expect(current_path).to eq login_path
      expect(page).to have_content("ログイン情報が正しくありません")
      visit root_path
      expect(page).not_to have_content("ログイン情報が正しくありません")
    end
  end
end
