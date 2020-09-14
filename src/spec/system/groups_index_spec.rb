require 'rails_helper'

RSpec.describe "GroupsIndex", type: :system do
  include TestHelper

  before do
    @user = create(:user)
    30.times do |n|
      eval("@group_#{n} = create(:groups, user: @user)")
    end
  end

  describe "コミュニティ一覧のテスト" do
    it "一覧が正常に表示されている" do
      log_in_as_system(@user)
      visit groups_path
      expect(current_path).to eq groups_path
      groups = Group.paginate(page: 1, per_page: 7)
      groups.each do |group|
        expect(page).to have_link group.name, href: group_path(group)
      end
    end

    it "フレンドリーフォロワーディング" do
      visit groups_path
      expect(current_path).to eq login_path
      fill_in "session_email", with: @user.email
      fill_in "session_password", with: "password"
      click_button "ログイン"
      expect(current_path).to eq groups_path
    end
  end
end
