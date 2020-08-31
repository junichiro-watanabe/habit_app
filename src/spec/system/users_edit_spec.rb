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
      fill_in "user_password", with: "password"
      fill_in "user_password_confirmation", with: "password"
      click_button "編集する"
      expect(current_path).to eq user_path(@user)
      expect(page).to have_selector '.alert-danger'
    end
  end
end
