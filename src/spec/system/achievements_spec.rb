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
    it "所属しているユーザ" do
      log_in_as_system(@user_1)
      visit group_path(@group)
      expect(page).not_to have_content "本日の目標は達成です！"
      expect(page).to have_content "本日の目標は未達です！"
      click_button "達成状況の変更"
      expect(current_path).to eq group_path(@group)
      expect(page).to have_content "本日の目標は達成です！"
      expect(page).not_to have_content "本日の目標は未達です！"
      click_button "達成状況の変更"
      expect(current_path).to eq group_path(@group)
      expect(page).not_to have_content "本日の目標は達成です！"
      expect(page).to have_content "本日の目標は未達です！"
    end

    it "所属していないユーザ" do
      log_in_as_system(@user_2)
      visit group_path(@group)
      expect(page).not_to have_content "本日の目標は達成です！"
      expect(page).not_to have_content "本日の目標は未達です！"
      expect(page).not_to have_button "達成状況の変更"
    end
  end

end
