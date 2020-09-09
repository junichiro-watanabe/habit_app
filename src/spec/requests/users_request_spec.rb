require 'rails_helper'

RSpec.describe "Users", type: :request do
  include SessionsHelper
  include TestHelper

  describe "indexのテスト" do
    let(:user){ create(:user) }
    it "getリクエスト：ログイン状態" do
      log_in_as(user)
      expect(logged_in?).to eq true
      get users_path
      expect(response).to have_http_status(200)
      expect(response).to render_template 'users/index'
    end

    it "getリクエスト：ログインしていない" do
      get users_path
      expect(response).to redirect_to login_path
      expect(flash.any?).to eq true
    end
  end

  describe "newのテスト" do
    it "getリクエスト" do
      get signup_path
      expect(response).to have_http_status(200)
      expect(response).to render_template('users/new')
    end
  end

  describe "createのテスト" do
    it "ユーザ作成：有効なユーザ情報" do
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

    it "ユーザ作成：無効なユーザ情報(全て空欄)" do
      expect{ post users_path,
              params: {user: {name: "",
                              email: "",
                              password: "",
                              password_confirmation: ""}}
      }.to change{ User.count }.by(+0)
      expect(response).to render_template 'users/new'
      expect(response.body).to include "class=\"alert alert-danger\""
    end

    it "ユーザ作成：無効なユーザ情報(すでに登録されているメールアドレス)" do
      user = create(:user)
      expect{ post users_path,
              params: {user: {name: "test",
                               email: "user@example.com",
                               password: "password",
                               password_confirmation: "password"}}
      }.to change{ User.count }.by(+0)
      expect(response).to render_template 'users/new'
      expect(response.body).to include "class=\"alert alert-danger\""
    end

    it "ユーザ作成：無効なユーザ情報(パスワード確認が一致しない)" do
      expect{ post users_path,
              params: {user: {name: "test",
                               email: "hogehoge@example.com",
                               password: "password",
                               password_confirmation: "p@ssw0rd"}}
      }.to change{ User.count }.by(+0)
      expect(response).to render_template 'users/new'
      expect(response.body).to include "class=\"alert alert-danger\""
    end
  end

  describe "showのテスト" do
    let(:user){ create(:user) }

    it "getリクエスト：ログイン状態" do
      log_in_as(user)
      expect(logged_in?).to eq true
      expect(current_user?(user)).to eq true
      get user_path(user)
      expect(response).to have_http_status(200)
      expect(response).to render_template 'users/show'
    end

    it "getリクエスト：ログインしていない" do
      get edit_user_path(user)
      expect(response).to redirect_to login_path
      expect(flash.any?).to eq true
    end
  end

  describe "editのテスト" do
    let(:user){ create(:user) }
    let(:other_user){ create(:other_user) }

    it "getリクエスト：ログイン状態" do
      log_in_as(user)
      expect(logged_in?).to eq true
      expect(current_user?(user)).to eq true
      get edit_user_path(user)
      expect(response).to have_http_status(200)
      expect(response).to render_template 'users/edit'
    end

    it "getリクエスト：ログインしていない" do
      get edit_user_path(user)
      expect(response).to redirect_to login_path
      expect(flash.any?).to eq true
    end

    it "getリクエスト：違うユーザ" do
      log_in_as(other_user)
      expect(logged_in?).to eq true
      get edit_user_path(user)
      expect(response).to redirect_to root_path
    end
  end

  describe "edit_imageのテスト" do
    let(:user){ create(:user) }
    let(:other_user){ create(:other_user) }

    it "getリクエスト：ログイン状態" do
      log_in_as user
      expect(logged_in?).to eq true
      expect(current_user?(user)).to eq true
      get "#{user_path(user)}/edit_image"
      expect(response).to have_http_status(200)
      expect(response).to render_template 'users/edit'
    end

    it "getリクエスト：ログインしていない" do
      get "#{user_path(user)}/edit_image"
      expect(response).to redirect_to login_path
      expect(flash.any?).to eq true
    end

    it "getリクエスト：違うユーザ" do
      log_in_as(other_user)
      get "#{user_path(user)}/edit_image"
      expect(response).to redirect_to root_path
    end
  end

  describe "updateのテスト" do
    let(:user){ create(:user) }
    let(:other_user){ create(:other_user) }

    it "プロフィール編集：有効なユーザ情報" do
      log_in_as(user)
      expect(logged_in?).to eq true
      name = "valid_user"
      email = "valid_email@valid.com"
      expect(user.name).not_to eq name
      expect(user.email).not_to eq email
      patch user_path(user),
            params: {edit_element: "profile",
                     user: {name: name,
                            email: email,
                            password: "valid_password",
                            password_confirmation: "valid_password"}}
      expect(response).to redirect_to user_path(user)
      expect(flash.any?).to eq true
      expect(user.reload.name).to eq name
      expect(user.reload.email).to eq email
    end

    it "プロフィール編集：無効なユーザ情報(全て空欄)" do
      log_in_as(user)
      expect(logged_in?).to eq true
      patch user_path(user),
            params: {edit_element: "profile",
                     user: {name: "",
                            email: "",
                            password: "",
                            password_confirmation: ""}}
      expect(response).to render_template 'users/edit'
      expect(response.body).to include "class=\"alert alert-danger\""
    end

    it "プロフィール編集：無効なユーザ情報(すでに登録されているメールアドレス)" do
      other_user
      log_in_as(user)
      expect(logged_in?).to eq true
      patch user_path(user),
            params: {edit_element: "profile",
                     user: {name: "test",
                            email: "other_user@example.com",
                            password: "password",
                            password_confirmation: "password"}}
      expect(response).to render_template 'users/edit'
      expect(response.body).to include "class=\"alert alert-danger\""
    end

    it "プロフィール編集：無効なユーザ情報(パスワード確認が一致しない)" do
      log_in_as(user)
      expect(logged_in?).to eq true
      patch user_path(user),
            params: {edit_element: "profile",
                     user: {name: "test",
                            email: "hogehoge@example.com",
                            password: "password",
                            password_confirmation: "p@ssw0rd"}}
      expect(response).to render_template 'users/edit'
      expect(response.body).to include "class=\"alert alert-danger\""
    end

    it "プロフィール編集：ログインしていない" do
      name = "valid_user"
      email = "valid_email@valid.com"
      expect(user.name).not_to eq name
      expect(user.email).not_to eq email
      patch user_path(user),
            params: {edit_element: "profile",
                     user: {name: name,
                            email: email,
                            password: "valid_password",
                            password_confirmation: "valid_password"}}
      expect(response).to redirect_to login_path
      expect(flash.any?).to eq true
      expect(user.reload.name).not_to eq name
      expect(user.reload.email).not_to eq email
    end

    it "プロフィール編集：違うユーザ" do
      log_in_as(other_user)
      expect(logged_in?).to eq true
      name = "valid_user"
      email = "valid_email@valid.com"
      patch user_path(user),
            params: {edit_element: "profile",
                     user: {name: name,
                            email: email,
                            password: "valid_password",
                            password_confirmation: "valid_password"}}
      expect(response).to redirect_to root_path
      expect(user.reload.name).not_to eq name
      expect(user.reload.email).not_to eq email
    end

    it "プロフィール画像変更：有効なファイル形式" do
      log_in_as(user)
      expect(logged_in?).to eq true
      expect(user.image.attached?).to eq false
      image = fixture_file_upload('spec/factories/images/img.png', 'image/png')
      patch user_path(user),
            params: {edit_element: "image",
                     user: {image: image}}
      expect(response).to redirect_to user_path(user)
      expect(flash.any?).to eq true
      expect(user.reload.image.attached?).to eq true
    end

    it "プロフィール画像変更：無効なファイル形式" do
      log_in_as(user)
      expect(logged_in?).to eq true
      expect(user.image.attached?).to eq false
      image = fixture_file_upload('spec/factories/images/img.txt', 'txt')
      patch user_path(user),
            params: {edit_element: "image",
                     user: {image: image}}
      expect(response).to render_template 'users/edit'
      expect(response.body).to include "class=\"alert alert-danger\""
      expect(user.reload.image.attached?).to eq false
    end

    it "プロフィール画像変更：ログインしていない" do
      expect(user.image.attached?).to eq false
      image = fixture_file_upload('spec/factories/images/img.png', 'image/png')
      patch user_path(user),
            params: {edit_element: "image",
                     user: {image: image}}
      expect(response).to redirect_to login_path
      expect(flash.any?).to eq true
      expect(user.reload.image.attached?).to eq false
    end

    it "プロフィール画像変更：違うユーザ" do
      log_in_as(other_user)
      expect(logged_in?).to eq true
      expect(user.image.attached?).to eq false
      image = fixture_file_upload('spec/factories/images/img.png', 'image/png')
      patch user_path(user),
            params: {edit_element: "image",
                     user: {image: image}}
      expect(response).to redirect_to root_path
      expect(user.reload.image.attached?).to eq false
    end

    it "プロフィール画像削除" do
      log_in_as(user)
      expect(logged_in?).to eq true
      expect(user.image.attached?).to eq false
      patch user_path(user),
            params: {edit_element: "image",
                     user: {image: nil}}
      expect(response).to redirect_to user_path(user)
      expect(flash.any?).to eq true
      expect(user.reload.image.attached?).to eq false
    end

    it "プロフィール画像削除：ログインしていない" do
      expect(user.image.attached?).to eq false
      image = fixture_file_upload('spec/factories/images/img.png', 'image/png')
      patch user_path(user),
            params: {edit_element: "image",
                     user: {image: nil}}
      expect(response).to redirect_to login_path
      expect(flash.any?).to eq true
      expect(user.reload.image.attached?).to eq false
    end

    it "プロフィール画像削除：違うユーザ" do
      log_in_as(other_user)
      expect(logged_in?).to eq true
      expect(user.image.attached?).to eq false
      image = fixture_file_upload('spec/factories/images/img.png', 'image/png')
      patch user_path(user),
            params: {edit_element: "image",
                     user: {image: nil}}
      expect(response).to redirect_to root_path
      expect(user.reload.image.attached?).to eq false
    end
  end

end
