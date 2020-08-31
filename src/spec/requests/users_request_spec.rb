require 'rails_helper'

RSpec.describe "Users", type: :request do
  include SessionsHelper
  include TestHelper

  describe "newのテスト" do
    it "getリクエスト" do
      get signup_path
      expect(response).to have_http_status(200)
      expect(response).to render_template('users/new')
    end
  end

  describe "createのテスト" do
    it "有効なユーザ情報" do
      expect{ post users_path,
              params: {user: {name: "valid_user",
                               email: "valid_email@valid.com",
                               password: "valid_password",
                               password_confirmation: "valid_password"}}
      }.to change{ User.count }.by(+1)
      user = User.last
      expect(response).to redirect_to user_path(user)
      expect(flash.empty?).to eq false
    end

    it "無効なユーザ情報" do
      expect{ post users_path,
              params: {user: {name: "",
                               email: "",
                               password: "",
                               password_confirmation: ""}}
      }.to change{ User.count }.by(+0)
      expect(response).to render_template 'users/new'
    end

  end

  describe "showのテスト" do
    let(:user){ create(:user) }

    it "getリクエスト(ログイン状態)" do
      log_in_as user
      expect(logged_in?).to eq true
      expect(current_user?(user)).to eq true
      get user_path(user)
      expect(response).to have_http_status(200)
      expect(response).to render_template 'users/show'
    end

    it "getリクエスト(ログインしていない)" do
      get edit_user_path(user)
      expect(response).to redirect_to root_path
    end
  end

  describe "editのテスト" do
    let(:user){ create(:user) }

    it "getリクエスト(ログイン状態)" do
      log_in_as user
      expect(logged_in?).to eq true
      expect(current_user?(user)).to eq true
      get edit_user_path(user)
      expect(response).to have_http_status(200)
      expect(response).to render_template 'users/edit'
    end

    it "getリクエスト(ログインしていない)" do
      get edit_user_path(user)
      expect(response).to redirect_to root_path
    end
  end

  describe "edit_imageのテスト" do
    let(:user){ create(:user) }

    it "getリクエスト(ログイン状態)" do
      log_in_as user
      expect(logged_in?).to eq true
      expect(current_user?(user)).to eq true
      get "#{user_path(user)}/edit_image"
      expect(response).to render_template 'users/edit'
    end

    it "getリクエスト(ログインしていない)" do
      get "#{user_path(user)}/edit_image"
      expect(response).to redirect_to root_path
    end
  end

end
