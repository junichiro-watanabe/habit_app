require 'rails_helper'

RSpec.describe "UsersIndex", type: :system do
  include TestHelper

  before do
    @user = create(:user)
    1.upto 10 do |n|
      eval("@user_#{n} = create(:users)")
    end
  end

  describe "ユーザ一覧のテスト" do
    it "一覧が正常に表示されている" do
      log_in_as_system(@user)
      visit users_path
      expect(current_path).to eq users_path
      users = User.paginate(page: 1, per_page: 7)
      users.each do |user|
        expect(page).to have_link user.name, href: user_path(user)
      end
    end

    it "フレンドリーフォロワーディング" do
      visit users_path
      expect(current_path).to eq login_path
      fill_in "session_email", with: @user.email
      fill_in "session_password", with: "password"
      click_button "ログイン"
      expect(current_path).to eq users_path
    end
  end
end
