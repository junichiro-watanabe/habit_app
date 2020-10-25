require 'rails_helper'

RSpec.describe "Messagings", type: :system do
  include TestHelper

  before do
    @user = create(:user)
    @other_user = create(:other_user)
    Message.create(sender: @other_user, receiver: @user, content: "content1")
  end

  describe "メッセージ送信のテスト" do
    it "メッセージ送信" do
      log_in_as_system(@user)
      visit message_path(@other_user)
      expect(current_path).to eq message_path(@other_user)
      expect(page).to have_link @other_user.name, href: user_path(@other_user)
      expect(page).to have_content "content1"
      expect(page).not_to have_link @user.name, href: user_path(@user)
      expect(page).not_to have_content "content2"
      fill_in "message",	with: "content2"
      click_button "送信"
      expect(page).to have_link @other_user.name, href: user_path(@other_user)
      expect(page).to have_content "content1"
      expect(page).to have_link @user.name, href: user_path(@user)
      expect(page).to have_content "content2"
    end
  end

  describe "メッセージ一覧のテスト" do
    it "メッセージ受信者が一覧に表示されている → メッセージ送信後コメントが修正されている" do
      log_in_as_system(@user)
      visit message_path(@user)
      expect(current_path).to eq message_path(@user)
      expect(page).to have_content "メッセージを受信しました"
      expect(page).not_to have_content "メッセージを送信しました"
      expect(page).to have_link nil, href: message_path(@other_user)
      click_link nil, href: message_path(@other_user)
      expect(current_path).to eq message_path(@other_user)
      expect(page).to have_link @other_user.name, href: user_path(@other_user)
      expect(page).to have_content "content1"
      expect(page).not_to have_link @user.name, href: user_path(@user)
      expect(page).not_to have_content "content2"
      fill_in "message",	with: "content2"
      click_button "送信"
      expect(page).to have_link @other_user.name, href: user_path(@other_user)
      expect(page).to have_content "content1"
      expect(page).to have_link @user.name, href: user_path(@user)
      expect(page).to have_content "content2"
      visit message_path(@user)
      expect(current_path).to eq message_path(@user)
      expect(page).not_to have_content "メッセージを受信しました"
      expect(page).to have_content "メッセージを送信しました"
    end

    it "フレンドリーフォロワーディング" do
      visit message_path(@user)
      expect(current_path).to eq root_path
      find('.glyphicon-log-in').click
      fill_in "session_email", with: @user.email
      fill_in "session_password", with: "password"
      click_button "ログイン"
      expect(current_path).to eq message_path(@user)
      expect(page).to have_content "メッセージを受信しました"
      expect(page).not_to have_content "メッセージを送信しました"
      expect(page).to have_link nil, href: message_path(@other_user)
    end
  end
end
