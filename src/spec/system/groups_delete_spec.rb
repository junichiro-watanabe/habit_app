require 'rails_helper'

RSpec.describe "GroupsDelete", type: :system do
  include TestHelper

  before do
    @user = create(:user)
    @group = create(:group)
  end

  describe "コミュニティ削除のテスト" do
    it "削除成功" do
      log_in_as_system(@user)
      visit "#{group_path(@group)}/delete_group"
      click_link "削除する"
      page.driver.browser.switch_to.alert.accept
      expect(current_path).to eq groups_path
      expect(page).to have_selector '.alert-success'
    end

    it "フレンドリーフォロワーディング" do
      visit "#{group_path(@group)}/delete_group"
      expect(current_path).to eq login_path
      fill_in "session_email", with: @user.email
      fill_in "session_password", with: "password"
      click_button "ログイン"
      expect(current_path).to eq "#{group_path(@group)}/delete_group"
      click_link "削除する"
      page.driver.browser.switch_to.alert.accept
      expect(current_path).to eq groups_path
      expect(page).to have_selector '.alert-success'
    end
  end
end
