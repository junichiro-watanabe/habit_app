require 'rails_helper'

RSpec.describe "Contacts", type: :system do
  include TestHelper

  before do
    @admin = create(:admin)
    @contact = create(:contact)
  end

  describe "問い合わせのテスト" do
    it "問い合わせ成功" do
      visit root_path
      expect(current_path).to eq root_path
      expect(page).to have_selector "#contact"
      find("#contact").click
      fill_in "contact_name", with: "valid_user"
      fill_in "contact_email", with: "valid_user@valid.com"
      fill_in "contact_subject", with: "valid_subject"
      fill_in "contact_text", with: "valid_text"
      click_button "送信"
      expect(current_path).to eq root_path
      expect(page).to have_selector '.alert-success'
    end

    it "問い合わせ失敗" do
      visit root_path
      expect(current_path).to eq root_path
      expect(page).to have_selector "#contact"
      find("#contact").click
      fill_in "contact_name", with: ""
      fill_in "contact_email", with: ""
      fill_in "contact_subject", with: ""
      fill_in "contact_text", with: ""
      click_button "送信"
      expect(page).to have_selector '.alert-danger'
    end
  end

  describe "問い合わせ一覧のテスト" do
    it "一覧が正常に表示される" do
      log_in_as_system(@admin)
      visit contacts_path
      expect(current_path).to eq contacts_path
      expect(page).to have_link nil, href: contact_path(@contact)
    end

    it "フレンドリーフォロワーディング" do
      visit contacts_path
      expect(current_path).to eq root_path
      find('.glyphicon-log-in').click
      fill_in "session_email", with: @admin.email
      fill_in "session_password", with: "password"
      click_button "ログイン"
      expect(current_path).to eq contacts_path
      expect(page).to have_link nil, href: contact_path(@contact)
    end
  end
end
