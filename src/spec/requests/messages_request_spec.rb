require 'rails_helper'

RSpec.describe "Messages", type: :request do
  include TestHelper
  include SessionsHelper

  before do
    @user = create(:user)
    @other_user = create(:other_user)
  end

  describe "showのテスト" do
    it "getリクエスト：ログイン状態" do
      log_in_as(@user)
      expect(logged_in?).to eq true
      get message_path(@other_user)
      expect(response).to have_http_status(200)
      expect(response).to render_template 'messages/show'
    end

    it "getリクエスト：ログインしていない" do
      get message_path(@other_user)
      expect(response).to redirect_to root_path
      expect(flash.any?).to eq true
    end
  end

  describe "updateのテスト" do
    it "メッセージ送信：ログイン状態" do
      log_in_as(@user)
      expect(logged_in?).to eq true
      expect { patch message_path(@other_user), params: { content: "content" } }.to change { Message.count }.by(+1)
    end

    it "メッセージ送信：ログインしていない" do
      expect { patch message_path(@other_user), params: { content: "content" } }.not_to change { Message.count }
      expect(response).to redirect_to root_path
      expect(flash.any?).to eq true
    end

    it "メッセージ送信：256文字超過" do
      log_in_as(@user)
      expect(logged_in?).to eq true
      expect { patch message_path(@other_user), params: { content: "a" * 256 } }.not_to change { Message.count }
    end
  end
end
