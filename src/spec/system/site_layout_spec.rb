require 'rails_helper'

RSpec.describe "SiteLayout", type: :system do
  include TestHelper

  before do
    @user = create(:user)
    @group = create(:group, user:@user)
    5.times do |n|
      eval("@user_#{n + 1} = create(:users)")
      eval("@user_#{n + 1}.belong(@group)")
    end
  end

  describe "ホーム画面のテスト" do
    it "リンクが正常" do
      visit root_path
      expect(page).to have_link "ホーム", href: root_path
      expect(page).to have_link "ログイン", href: login_path
      expect(page).to have_link "新規登録", href: signup_path
      expect(page).to have_link "今すぐ始める", href: signup_path
    end
  end

  describe "ユーザ紹介画面のテスト" do
    it "リンクが正常" do
      log_in_as_system(@user)
      visit user_path(@user_1)
      expect(page).to have_link "フォロー", href: "#"
      expect(page).to have_link "フォロワー", href: "#"
      expect(page).to have_link "主催コミュニティ", href: owning_user_path(@user_1)
      expect(page).to have_link "参加コミュニティ", href: belonging_user_path(@user_1)
    end

    it "表示情報が正常" do
      log_in_as_system(@user)
      visit user_path(@user_1)
      expect(page).to have_content @user_1.name
      expect(page).to have_content @user_1.introduction
    end
  end

  describe "グループ紹介画面のテスト" do
    it "リンクが正常" do
      log_in_as_system(@user)
      visit group_path(@group)
      expect(page).to have_link @group.user.name, href: user_path(@group.user)
      expect(page).to have_link "#{@group.members.count}人が参加", href: member_group_path(@group)
    end

    it "表示情報が正常" do
      log_in_as_system(@user)
      visit group_path(@group)
      expect(page).to have_content @group.name
      expect(page).to have_content @group.habit
      expect(page).to have_content @group.overview
    end
  end

end
