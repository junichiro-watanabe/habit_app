require 'rails_helper'

RSpec.describe "UsersDelete", type: :system do
  include TestHelper

  before do
    @user = create(:user)
  end

  describe "アカウント閉鎖のテスト" do
    it "閉鎖成功" do
      log_in_as_system(@user)
      visit delete_user_path(@user)
      click_link "閉鎖する"
      page.driver.browser.switch_to.alert.accept
      expect(page).to have_selector '.alert-success'
      expect(current_path).to eq root_path
    end

    it "フレンドリーフォロワーディング" do
      visit delete_user_path(@user)
      expect(current_path).to eq root_path
      find('.glyphicon-log-in').click
      fill_in "session_email", with: @user.email
      fill_in "session_password", with: "password"
      click_button "ログイン"
      expect(current_path).to eq delete_user_path(@user)
      click_link "閉鎖する"
      page.driver.browser.switch_to.alert.accept
      expect(page).to have_selector '.alert-success'
      expect(current_path).to eq root_path
    end
  end
end
