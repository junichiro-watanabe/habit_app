require 'rails_helper'

RSpec.describe "UsersEdit", type: :system do
  include TestHelper

  before do
    @user = create(:user)
  end

  describe "プロフィール編集のテスト" do
    it "編集成功" do
      log_in_as_system(@user)
      visit edit_user_path(@user)
      fill_in "user_name", with: "valid_name"
      fill_in "user_email", with: "valid_email@valid.com"
      fill_in "user_introduction", with: "valid_introduction"
      fill_in "user_password", with: "password"
      fill_in "user_password_confirmation", with: "password"
      click_button "編集する"
      expect(current_path).to eq user_path(@user)
      expect(page).to have_selector '.alert-success'
    end

    it "編集失敗" do
      log_in_as_system(@user)
      visit edit_user_path(@user)
      fill_in "user_name", with: ""
      fill_in "user_email", with: ""
      fill_in "user_introduction", with: ""
      fill_in "user_password", with: "password"
      fill_in "user_password_confirmation", with: "password"
      click_button "編集する"
      expect(current_path).to eq user_path(@user)
      expect(page).to have_selector '.alert-danger'
    end

    it "フレンドリーフォロワーディング" do
      visit edit_user_path(@user)
      expect(current_path).to eq root_path
      find('.glyphicon-log-in').click
      fill_in "session_email", with: @user.email
      fill_in "session_password", with: "password"
      click_button "ログイン"
      expect(current_path).to eq edit_user_path(@user)
      fill_in "user_name", with: "valid_name"
      fill_in "user_email", with: "valid_email@valid.com"
      fill_in "user_introduction", with: "valid_introduction"
      fill_in "user_password", with: "password"
      fill_in "user_password_confirmation", with: "password"
      click_button "編集する"
      expect(current_path).to eq user_path(@user)
      expect(page).to have_selector '.alert-success'
    end
  end

  describe "プロフィール画像変更のテスト" do
    it "プロフィール画像変更 →　プロフィール画面削除" do
      log_in_as_system(@user)
      visit edit_image_user_path(@user)
      image = File.join(Rails.root, "spec/factories/images/img.png")
      attach_file('user_image', image)
      click_button "変更する"
      expect(current_path).to eq user_path(@user)
      expect(page).to have_selector '.alert-success'
      visit edit_image_user_path(@user)
      click_button "変更する"
      expect(current_path).to eq user_path(@user)
      expect(page).to have_selector '.alert-success'
    end

    it "プロフィール画像変更失敗" do
      log_in_as_system(@user)
      visit edit_image_user_path(@user)
      image = File.join(Rails.root, "spec/factories/images/img.txt")
      attach_file('user_image', image)
      click_button "変更する"
      expect(current_path).to eq user_path(@user)
      expect(page).to have_selector '.alert-danger'
    end

    it "フレンドリーフォロワーディング" do
      visit edit_image_user_path(@user)
      expect(current_path).to eq root_path
      find('.glyphicon-log-in').click
      fill_in "session_email", with: @user.email
      fill_in "session_password", with: "password"
      click_button "ログイン"
      expect(current_path).to eq edit_image_user_path(@user)
      image = File.join(Rails.root, "spec/factories/images/img.png")
      attach_file('user_image', image)
      click_button "変更する"
      expect(current_path).to eq user_path(@user)
      expect(page).to have_selector '.alert-success'
    end
  end
end
