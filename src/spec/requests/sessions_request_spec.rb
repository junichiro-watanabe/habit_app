require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  include SessionsHelper
  include TestHelper

  before do
    @user = create(:user)
    @guest = create(:guest)
  end

  describe "newのテスト" do
    it "getリクエスト" do
      get login_path
      expect(response).to have_http_status(200)
      expect(response).to render_template 'sessions/new'
    end
  end

  describe "createのテスト" do
    it "有効なログイン情報" do
      post login_path, params: {session: {email: @user.email,
                                          password: "password"}}
      expect(logged_in?).to eq true
      expect(response).to redirect_to user_path(@user)
    end

    it "emailが無効" do
      post login_path, params: {session: {email: "invalid_email",
                                          password: "password"}}
      expect(logged_in?).to eq false
      expect(response).to render_template 'sessions/new'
      expect(flash.any?).to eq true
    end

    it "passwordが無効" do
      post login_path, params: {session: {email: @user.email,
                                          password: "invalid_password"}}
      expect(logged_in?).to eq false
      expect(response).to render_template 'sessions/new'
      expect(flash.any?).to eq true
    end

    it "email/passwordが無効" do
      post login_path, params: {session: {email: "invalid_email",
                                          password: "invalid_password"}}
      expect(logged_in?).to eq false
      expect(response).to render_template 'sessions/new'
      expect(flash.any?).to eq true
    end
  end

  describe "create_guestのテスト" do
    it "ゲストユーザログイン" do
      get "/login_guest"
      expect(logged_in?).to eq true
      expect(response).to redirect_to user_path(@guest)
    end
  end

  describe "destroyのテスト" do
    it "ログアウト" do
      log_in_as @user
      expect(logged_in?).to eq true
      delete login_path
      expect(logged_in?).to eq false
      expect(response).to redirect_to root_path
    end
  end

end
