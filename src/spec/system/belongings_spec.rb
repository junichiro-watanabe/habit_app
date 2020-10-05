require 'rails_helper'

RSpec.describe "Belongings", type: :system do
  include TestHelper

  before do
    @user = create(:user)
    @group = create(:group, user:@user)
    1.upto 10 do |n|
      eval("@group_#{n} = create(:groups, user: @user)")
    end
    1.upto 9 do |n|
      eval("@user_#{n} = create(:users)")
      1.upto 10 do |m|
        eval("@user_#{n}.belong(@group_#{m})")
      end
    end
  end

  describe "主催コミュニティ一覧のテスト" do
    it "一覧が正常に表示されている" do
      log_in_as_system(@user)
      visit owning_user_path(@user)
      expect(current_path).to eq owning_user_path(@user)
      groups = @user.groups.paginate(page: 1, per_page: 7)
      groups.each do |group|
        expect(page).to have_link group.name, href: group_path(group)
      end
    end

    it "フレンドリーフォロワーディング" do
      visit owning_user_path(@user)
      expect(current_path).to eq login_path
      fill_in "session_email", with: @user.email
      fill_in "session_password", with: "password"
      click_button "ログイン"
      expect(current_path).to eq owning_user_path(@user)
      groups = @user.groups.paginate(page: 1, per_page: 7)
      groups.each do |group|
        expect(page).to have_link group.name, href: group_path(group)
      end
    end
  end

  describe "参加コミュニティ一覧のテスト" do
    it "一覧が正常に表示されている" do
      log_in_as_system(@user_1)
      visit belonging_user_path(@user_1)
      expect(current_path).to eq belonging_user_path(@user_1)
      groups = @user_1.belonging.paginate(page: 1, per_page: 7)
      groups.each do |group|
        expect(page).to have_link group.name, href: group_path(group)
      end
    end

    it "フレンドリーフォロワーディング" do
      visit belonging_user_path(@user_1)
      expect(current_path).to eq login_path
      fill_in "session_email", with: @user_1.email
      fill_in "session_password", with: "password"
      click_button "ログイン"
      expect(current_path).to eq belonging_user_path(@user_1)
      groups = @user_1.belonging.paginate(page: 1, per_page: 7)
      groups.each do |group|
        expect(page).to have_link group.name, href: group_path(group)
      end
    end
  end

  describe "メンバー一覧のテスト" do
    it "一覧が正常に表示されている" do
      log_in_as_system(@user)
      visit member_group_path(@group_1)
      expect(current_path).to eq member_group_path(@group_1)
      users = @group_1.members.paginate(page: 1, per_page: 7)
      users.each do |user|
        expect(page).to have_link user.name, href: user_path(user)
      end
    end

    it "フレンドリーフォロワーディング" do
      visit member_group_path(@group_1)
      expect(current_path).to eq login_path
      fill_in "session_email", with: @user.email
      fill_in "session_password", with: "password"
      click_button "ログイン"
      expect(current_path).to eq member_group_path(@group_1)
      users = @group_1.members.paginate(page: 1, per_page: 7)
      users.each do |user|
        expect(page).to have_link user.name, href: user_path(user)
      end
    end
  end

  describe "参加/脱退のテスト" do
    it "参加する　→　目標達成項目表示 → 脱退する → 目標達成項目非表示" do
      log_in_as_system(@user)
      visit group_path(@group_10)
      expect(page).to have_button "参加する"
      expect(page).not_to have_button "脱退する"
      expect(page).not_to have_content "このコミュニティに参加しています"
      expect(page).not_to have_content "本日の目標は未達です！"
      expect(page).not_to have_button "達成状況の変更"
      click_button "参加する"
      expect(current_path).to eq group_path(@group_10)
      expect(page).not_to have_button "参加する"
      expect(page).to have_button "脱退する"
      expect(page).to have_content "このコミュニティに参加しています"
      expect(page).to have_content "本日の目標は未達です！"
      expect(page).to have_button "達成状況の変更"
      click_button "脱退する"
      expect(current_path).to eq group_path(@group_10)
      expect(page).to have_button "参加する"
      expect(page).not_to have_button "脱退する"
      expect(page).not_to have_content "このコミュニティに参加しています"
      expect(page).not_to have_content "本日の目標は未達です！"
      expect(page).not_to have_button "達成状況の変更"
    end
  end
end
