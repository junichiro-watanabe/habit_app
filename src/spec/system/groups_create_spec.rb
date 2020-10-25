require 'rails_helper'

RSpec.describe "GroupsCreate", type: :system do
  include TestHelper

  before do
    @user = create(:user)
  end

  describe "コミュニティ作成のテスト" do
    it "作成成功" do
      log_in_as_system(@user)
      visit '/create_group'
      fill_in "group_name", with: "valid_name"
      fill_in "group_habit", with: "valid_habit"
      fill_in "group_overview", with: "valid_overview"
      click_button "コミュニティ作成"
      group = Group.last
      expect(current_path).to eq group_path(group)
      expect(page).to have_selector '.alert-success'
    end

    it "作成失敗" do
      log_in_as_system(@user)
      visit '/create_group'
      fill_in "group_name", with: "a" * 51
      fill_in "group_habit", with: "a" * 51
      fill_in "group_overview", with: "a" * 256
      click_button "コミュニティ作成"
      expect(current_path).to eq groups_path
      expect(page).to have_selector '.alert-danger'
    end

    it "フレンドリーフォロワーディング" do
      visit '/create_group'
      expect(current_path).to eq root_path
      find('.glyphicon-log-in').click
      fill_in "session_email", with: @user.email
      fill_in "session_password", with: "password"
      click_button "ログイン"
      expect(current_path).to eq '/create_group'
      fill_in "group_name", with: "valid_name"
      fill_in "group_habit", with: "valid_habit"
      fill_in "group_overview", with: "valid_overview"
      click_button "コミュニティ作成"
      group = Group.last
      expect(current_path).to eq group_path(group)
      expect(page).to have_selector '.alert-success'
    end
  end
end
