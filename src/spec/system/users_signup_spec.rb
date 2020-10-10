require 'rails_helper'

RSpec.describe "UsersSignup", type: :system do
  describe "サインアップのテスト" do
    it "サインアップ成功" do
      visit signup_path
      expect(current_path).to eq signup_path
      fill_in "user_name", with: "valid_user"
      fill_in "user_email", with: "valid_user@valid.com"
      fill_in "user_introduction", with: "valid_introduction"
      fill_in "user_password", with: "password"
      fill_in "user_password_confirmation", with: "password"
      click_button "新規登録"
      user = User.last
      expect(current_path).to eq user_path(user)
      expect(page).to have_selector '.alert-success'
    end

    it "サインアップ失敗" do
      visit signup_path
      expect(current_path).to eq signup_path
      fill_in "user_name", with: ""
      fill_in "user_email", with: ""
      fill_in "user_introduction", with: ""
      fill_in "user_password", with: "password"
      fill_in "user_password_confirmation", with: "password"
      click_button "新規登録"
      expect(current_path).to eq users_path
      expect(page).to have_selector '.alert-danger'
    end
  end
end
