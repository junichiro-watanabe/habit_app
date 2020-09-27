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
      expect(page).to have_content "未達"
      click_button "達成状況の変更"
      expect(current_path).to eq group_path(@group)
      expect(page).to have_content "達成"
      click_button "達成状況の変更"
      expect(current_path).to eq group_path(@group)
      expect(page).to have_content "未達"
    end

    it "所属していないユーザ" do
      log_in_as_system(@user_2)
      visit group_path(@group)
      expect(page).not_to have_content "達成"
      expect(page).not_to have_content "未達"
      expect(page).not_to have_button "達成状況の変更"
    end
  end

end
