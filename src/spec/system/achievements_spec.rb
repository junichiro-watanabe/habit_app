require 'rails_helper'

RSpec.describe "Achievements", type: :system do
  include TestHelper

  before do
    @user = create(:user)
    @group = create(:group, user:@user)
    2.times do |n|
      eval("@user_#{n + 1} = create(:users)")
    end
    @user_1.belong(@group)
  end

  describe "目標達成 → 目標未達" do
    it "所属しているユーザ：グループ紹介画面から" do
      log_in_as_system(@user_1)
      visit group_path(@group)
      expect(page).not_to have_content "本日の目標は達成です！"
      expect(page).to have_content "本日の目標は未達です！"
      expect(page).to have_button "達成状況の変更"
      expect(page).to have_selector "#achieve_#{@group.id}"
      expect(page).not_to have_selector "#encouragement"
      expect(page).not_to have_button "煽る"
      click_button "達成状況の変更"
      expect(current_path).to eq group_path(@group)
      expect(page).to have_content "本日の目標は達成です！"
      expect(page).not_to have_content "本日の目標は未達です！"
      expect(page).to have_button "達成状況の変更"
      expect(page).to have_selector "#achieve_#{@group.id}"
      expect(page).to have_selector "#encouragement"
      expect(page).to have_button "煽る"
      click_button "達成状況の変更"
      expect(current_path).to eq group_path(@group)
      expect(page).not_to have_content "本日の目標は達成です！"
      expect(page).to have_content "本日の目標は未達です！"
      expect(page).to have_button "達成状況の変更"
      expect(page).to have_selector "#achieve_#{@group.id}"
      expect(page).not_to have_selector "#encouragement"
      expect(page).not_to have_button "煽る"
    end

    it "所属していないユーザ" do
      log_in_as_system(@user_2)
      visit group_path(@group)
      expect(page).not_to have_content "本日の目標は達成です！"
      expect(page).not_to have_content "本日の目標は未達です！"
      expect(page).not_to have_button "達成状況の変更"
      expect(page).not_to have_selector "#achieve_#{@group.id}"
      expect(page).not_to have_button "達成状況の変更"
    end
  end

  describe "煽り投稿のテスト" do
    it "煽り投稿成功" do

    end

    it "煽り投稿失敗" do

    end
  end

end
