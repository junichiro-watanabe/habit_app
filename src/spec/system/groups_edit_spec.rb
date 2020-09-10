require 'rails_helper'

RSpec.describe "GroupsEdit", type: :system do
  include TestHelper

  before do
    @user = create(:user)
    @group = create(:group)
  end

  describe "コミュニティ情報編集のテスト" do
    it "編集成功" do
      log_in_as_system(@user)
      visit edit_group_path(@group)
      fill_in "group_name", with: "valid_name"
      fill_in "group_habit", with: "valid_habit"
      fill_in "group_overview", with: "valid_overview"
      click_button "編集する"
      expect(current_path).to eq group_path(@group)
      expect(page).to have_selector '.alert-success'
    end

    it "編集失敗" do
      log_in_as_system(@user)
      visit edit_group_path(@group)
      fill_in "group_name", with: "a"*51
      fill_in "group_habit", with: "a"*51
      fill_in "group_overview", with: "a"*256
      click_button "編集する"
      expect(current_path).to eq group_path(@group)
      expect(page).to have_selector '.alert-danger'
    end

    it "フレンドリーフォロワーディング" do
      visit edit_group_path(@group)
      expect(current_path).to eq login_path
      fill_in "session_email", with: @user.email
      fill_in "session_password", with: "password"
      click_button "ログイン"
      expect(current_path).to eq edit_group_path(@group)
      fill_in "group_name", with: "valid_name"
      fill_in "group_habit", with: "valid_habit"
      fill_in "group_overview", with: "valid_overview"
      click_button "編集する"
      expect(current_path).to eq group_path(@group)
      expect(page).to have_selector '.alert-success'
    end
  end

  describe "コミュニティ画像変更" do
    it "画像変更 → 画像削除" do
      log_in_as_system(@user)
      visit "#{group_path(@group)}/edit_image"
      image = File.join(Rails.root, "spec/factories/images/img.png")
      attach_file("group_image", image)
      click_button "変更する"
      expect(current_path).to eq group_path(@group)
      expect(page).to have_selector '.alert-success'
      visit "#{group_path(@group)}/edit_image"
      click_button "変更する"
      expect(current_path).to eq group_path(@group)
      expect(page).to have_selector '.alert-success'
    end

    it "画像変更失敗" do
      log_in_as_system(@user)
      visit "#{group_path(@group)}/edit_image"
      image = File.join(Rails.root, "spec/factories/images/img.txt")
      attach_file("group_image", image)
      click_button "変更する"
      expect(current_path).to eq group_path(@group)
      expect(page).to have_selector '.alert-danger'
    end

    it "フレンドリーフォロワーディング" do
      visit "#{group_path(@group)}/edit_image"
      expect(current_path).to eq login_path
      fill_in "session_email", with: @user.email
      fill_in "session_password", with: "password"
      click_button "ログイン"
      expect(current_path).to eq "#{group_path(@group)}/edit_image"
      image = File.join(Rails.root, "spec/factories/images/img.png")
      attach_file("group_image", image)
      click_button "変更する"
      expect(current_path).to eq group_path(@group)
      expect(page).to have_selector '.alert-success'
    end
  end
end
