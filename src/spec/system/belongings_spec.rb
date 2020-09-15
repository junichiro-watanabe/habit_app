require 'rails_helper'

RSpec.describe "Belongings", type: :system do
  include TestHelper

  before do
    @user = create(:user)
    @group = create(:group, user:@user)
    10.times do |n|
      eval("@group_#{n} = create(:groups, user: @user)")
    end
    10.times do |n|
      eval("@user_#{n} = create(:users)")
      eval("@user_#{n}.belong(@group)")
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

  describe "所属コミュニティ一覧のテスト" do
    it "一覧が正常に表示されている" do
      log_in_as_system(@user)
      visit belonging_user_path(@user)
      expect(current_path).to eq belonging_user_path(@user)
      groups = @user.belonging.paginate(page: 1, per_page: 7)
      groups.each do |group|
        expect(page).to have_link group.name, href: group_path(group)
      end
    end

    it "フレンドリーフォロワーディング" do
      visit belonging_user_path(@user)
      expect(current_path).to eq login_path
      fill_in "session_email", with: @user.email
      fill_in "session_password", with: "password"
      click_button "ログイン"
      expect(current_path).to eq belonging_user_path(@user)
      groups = @user.belonging.paginate(page: 1, per_page: 7)
      groups.each do |group|
        expect(page).to have_link group.name, href: group_path(group)
      end
    end
  end

  describe "メンバー一覧のテスト" do
    it "一覧が正常に表示されている" do
      log_in_as_system(@user)
      visit member_group_path(@group)
      expect(current_path).to eq member_group_path(@group)
      users = @group.members.paginate(page: 1, per_page: 7)
      users.each do |user|
        expect(page).to have_link user.name, href: user_path(user)
      end
    end

    it "フレンドリーフォロワーディング" do
      visit member_group_path(@group)
      expect(current_path).to eq login_path
      fill_in "session_email", with: @user.email
      fill_in "session_password", with: "password"
      click_button "ログイン"
      expect(current_path).to eq member_group_path(@group)
      users = @group.members.paginate(page: 1, per_page: 7)
      users.each do |user|
        expect(page).to have_link user.name, href: user_path(user)
      end
    end
  end
end
