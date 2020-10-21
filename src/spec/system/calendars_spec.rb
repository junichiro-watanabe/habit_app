require 'rails_helper'

RSpec.describe "Calendars", type: :system do
  include TestHelper

  before do
    @user = create(:user)
    @other_user = create(:other_user)
    1.upto 5 do |n|
      eval("@group_#{n} = create(:groups, user: @user)")
      eval("@user.belong(@group_#{n})")
      eval("@user.toggle_achieved(@group_#{n})")
      eval("@other_user.belong(@group_#{n})")
      eval("@other_user.toggle_achieved(@group_#{n})")
    end
  end

  describe "自分の達成カレンダーのテスト" do
    it "日付をクリックすると達成目標が表示される" do
      log_in_as_system(@user)
      visit user_path(@user)
      expect(current_path).to eq user_path(@user)
      find(".day-#{Date.today}").click
      history = @user.achievement_history
      history[Date.today].each do |h|
        expect(page).to have_link h[:group_name], href: h[:group_path]
        expect(page).to have_content "#{Date.today} 分の #{h[:group_name]} の目標を達成しました。"
      end
    end

    it "達成数に応じてクラスが変化する" do
      log_in_as_system(@user)
      visit user_path(@user)
      expect(current_path).to eq user_path(@user)
      within ".react-calendar" do
        expect(page).to have_selector ".high"
        expect(page).not_to have_selector ".middle"
        expect(page).not_to have_selector ".row"
      end
      1.upto 2 do |n|
        eval("@user.toggle_achieved(@group_#{n})")
      end
      visit user_path(@user)
      within ".react-calendar" do
        expect(page).not_to have_selector ".high"
        expect(page).to have_selector ".middle"
        expect(page).not_to have_selector ".row"
      end
      3.upto 4 do |n|
        eval("@user.toggle_achieved(@group_#{n})")
      end
      visit user_path(@user)
      within ".react-calendar" do
        expect(page).not_to have_selector ".high"
        expect(page).not_to have_selector ".middle"
        expect(page).to have_selector ".row"
      end
      @user.toggle_achieved(@group_5)
      visit user_path(@user)
      within ".react-calendar" do
        expect(page).not_to have_selector ".high"
        expect(page).not_to have_selector ".middle"
        expect(page).not_to have_selector ".row"
      end
    end
  end

  describe "他のユーザの達成カレンダーのテスト" do
    it "日付をクリックすると達成目標が表示される" do
      log_in_as_system(@user)
      visit user_path(@other_user)
      expect(current_path).to eq user_path(@other_user)
      find(".day-#{Date.today}").click
      history = @other_user.achievement_history
      history[Date.today].each do |h|
        expect(page).to have_link h[:group_name], href: h[:group_path]
        expect(page).to have_content "#{Date.today} 分の #{h[:group_name]} の目標を達成しました。"
      end
    end

    it "達成数に応じてクラスが変化する" do
      log_in_as_system(@user)
      visit user_path(@other_user)
      expect(current_path).to eq user_path(@other_user)
      within ".react-calendar" do
        expect(page).to have_selector ".high"
        expect(page).not_to have_selector ".middle"
        expect(page).not_to have_selector ".row"
      end
      1.upto 2 do |n|
        eval("@other_user.toggle_achieved(@group_#{n})")
      end
      visit user_path(@other_user)
      within ".react-calendar" do
        expect(page).not_to have_selector ".high"
        expect(page).to have_selector ".middle"
        expect(page).not_to have_selector ".row"
      end
      3.upto 4 do |n|
        eval("@other_user.toggle_achieved(@group_#{n})")
      end
      visit user_path(@other_user)
      within ".react-calendar" do
        expect(page).not_to have_selector ".high"
        expect(page).not_to have_selector ".middle"
        expect(page).to have_selector ".row"
      end
      @other_user.toggle_achieved(@group_5)
      visit user_path(@other_user)
      within ".react-calendar" do
        expect(page).not_to have_selector ".high"
        expect(page).not_to have_selector ".middle"
        expect(page).not_to have_selector ".row"
      end
    end
  end
end
