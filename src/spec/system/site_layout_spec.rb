require 'rails_helper'

RSpec.describe "SiteLayout", type: :system do
  describe "ホーム画面のテスト" do
    it "リンクが正常" do
      visit root_path
      expect(page).to have_link "新規登録", href: signup_path
      expect(page).to have_link "今すぐ始める", href: signup_path
    end
  end
end
