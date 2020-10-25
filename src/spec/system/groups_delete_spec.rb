require 'rails_helper'

RSpec.describe "GroupsDelete", type: :system do
  include TestHelper

  before do
    @user = create(:user)
    @other_user = create(:other_user)
    @group = create(:group, user: @user)
  end

  describe "コミュニティ削除のテスト" do
    it "削除成功" do
      log_in_as_system(@user)
      visit group_path(@group)
      expect(page).to have_link "削除する", href: delete_group_path(@group)
      click_link "削除する"
      expect(current_path).to eq delete_group_path(@group)
      click_link "削除する"
      page.driver.browser.switch_to.alert.accept
      expect(page).to have_selector '.alert-success'
      expect(current_path).to eq groups_path
    end

    it "フレンドリーフォロワーディング" do
      visit delete_group_path(@group)
      expect(current_path).to eq root_path
      find('.glyphicon-log-in').click
      fill_in "session_email", with: @user.email
      fill_in "session_password", with: "password"
      click_button "ログイン"
      expect(current_path).to eq delete_group_path(@group)
      click_link "削除する"
      page.driver.browser.switch_to.alert.accept
      expect(page).to have_selector '.alert-success'
      expect(current_path).to eq groups_path
    end

    it "オーナ以外の人にはリンクが表示されない" do
      log_in_as_system(@other_user)
      visit group_path(@group)
      expect(page).not_to have_link "削除する", href: delete_group_path(@group)
    end
  end
end
