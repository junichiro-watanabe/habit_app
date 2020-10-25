require 'rails_helper'

RSpec.describe "Users", type: :request do
  include SessionsHelper
  include TestHelper

  before do
    @user = create(:user)
    @other_user = create(:other_user)
    @admin = create(:admin)
    30.times do |n|
      eval("@user_#{n} = create(:users)")
    end
  end

  describe "indexのテスト" do
    it "getリクエスト：ログイン状態" do
      log_in_as(@user)
      expect(logged_in?).to eq true
      get users_path
      expect(response).to have_http_status(200)
      expect(response).to render_template 'shared/user_index'
    end

    it "getリクエスト：ログインしていない" do
      get users_path
      expect(response).to redirect_to root_path
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
      expect do
        post users_path,
             params: { user: { name: "valid_user",
                               email: "valid_email@valid.com",
                               introduction: "valid_introduction",
                               password: "valid_password",
                               password_confirmation: "valid_password" } }
      end.to change { User.count }.by(+1)
      user = User.last
      expect(response).to redirect_to user_path(user)
      expect(flash.empty?).to eq false
    end

    it "ユーザ作成：無効なユーザ情報(全て空欄)" do
      expect do
        post users_path,
             params: { user: { name: "",
                               email: "",
                               introduction: "",
                               password: "",
                               password_confirmation: "" } }
      end.to change { User.count }.by(+0)
      expect(response).to render_template 'users/new'
      expect(response.body).to include "class=\"alert alert-danger\""
    end

    it "ユーザ作成：無効なユーザ情報(すでに登録されているメールアドレス)" do
      expect do
        post users_path,
             params: { user: { name: "test",
                               email: "user@example.com",
                               introduction: "valid_introduction",
                               password: "password",
                               password_confirmation: "password" } }
      end.to change { User.count }.by(+0)
      expect(response).to render_template 'users/new'
      expect(response.body).to include "class=\"alert alert-danger\""
    end

    it "ユーザ作成：無効なユーザ情報(パスワード確認が一致しない)" do
      expect do
        post users_path,
             params: { user: { name: "test",
                               email: "hogehoge@example.com",
                               introduction: "valid_introduction",
                               password: "password",
                               password_confirmation: "p@ssw0rd" } }
      end.to change { User.count }.by(+0)
      expect(response).to render_template 'users/new'
      expect(response.body).to include "class=\"alert alert-danger\""
    end
  end

  describe "showのテスト" do
    it "getリクエスト：ログイン状態" do
      log_in_as(@user)
      expect(logged_in?).to eq true
      expect(current_user?(@user)).to eq true
      get user_path(@user)
      expect(response).to have_http_status(200)
      expect(response).to render_template 'users/show'
    end

    it "getリクエスト：ログイン状態(他のユーザ)" do
      log_in_as(@user)
      expect(logged_in?).to eq true
      expect(current_user?(@user)).to eq true
      get user_path(@other_user)
      expect(response).to have_http_status(200)
      expect(response).to render_template 'users/show'
      expect(response).not_to render_template 'users/_achievement_information'
      expect(response).not_to render_template 'users/_encouragement_information'
    end

    it "getリクエスト：ログインしていない" do
      get edit_user_path(@user)
      expect(response).to redirect_to root_path
      expect(flash.any?).to eq true
    end
  end

  describe "editのテスト" do
    it "getリクエスト：ログイン状態" do
      log_in_as(@user)
      expect(logged_in?).to eq true
      expect(current_user?(@user)).to eq true
      get edit_user_path(@user)
      expect(response).to have_http_status(200)
      expect(response).to render_template 'users/edit'
    end

    it "getリクエスト：ログインしていない" do
      get edit_user_path(@user)
      expect(response).to redirect_to root_path
      expect(flash.any?).to eq true
    end

    it "getリクエスト：違うユーザ" do
      log_in_as(@other_user)
      expect(logged_in?).to eq true
      get edit_user_path(@user)
      expect(response).to redirect_to root_path
    end

    it "getリクエスト：管理者ユーザ" do
      log_in_as(@admin)
      expect(logged_in?).to eq true
      get edit_user_path(@user)
      expect(response).to have_http_status(200)
      expect(response).to render_template 'users/edit'
    end
  end

  describe "edit_imageのテスト" do
    it "getリクエスト：ログイン状態" do
      log_in_as(@user)
      expect(logged_in?).to eq true
      expect(current_user?(@user)).to eq true
      get edit_image_user_path(@user)
      expect(response).to have_http_status(200)
      expect(response).to render_template 'users/edit_image'
    end

    it "getリクエスト：ログインしていない" do
      get edit_image_user_path(@user)
      expect(response).to redirect_to root_path
      expect(flash.any?).to eq true
    end

    it "getリクエスト：違うユーザ" do
      log_in_as(@other_user)
      get edit_image_user_path(@user)
      expect(response).to redirect_to root_path
    end
  end

  describe "updateのテスト" do
    it "プロフィール編集：有効なユーザ情報" do
      log_in_as(@user)
      expect(logged_in?).to eq true
      name = "valid_user"
      email = "valid_email@valid.com"
      expect(@user.name).not_to eq name
      expect(@user.email).not_to eq email
      patch user_path(@user),
            params: { edit_element: "profile",
                      user: { name: name,
                              email: email,
                              introduction: "valid_introduction",
                              password: "valid_password",
                              password_confirmation: "valid_password" } }
      expect(response).to redirect_to user_path(@user)
      expect(flash.any?).to eq true
      expect(@user.reload.name).to eq name
      expect(@user.reload.email).to eq email
    end

    it "プロフィール編集：有効なユーザ情報(管理者ユーザ)" do
      log_in_as(@admin)
      expect(logged_in?).to eq true
      name = "valid_user"
      email = "valid_email@valid.com"
      expect(@user.name).not_to eq name
      expect(@user.email).not_to eq email
      patch user_path(@user),
            params: { edit_element: "profile",
                      user: { name: name,
                              email: email,
                              introduction: "valid_introduction",
                              password: "valid_password",
                              password_confirmation: "valid_password" } }
      expect(response).to redirect_to user_path(@user)
      expect(flash.any?).to eq true
      expect(@user.reload.name).to eq name
      expect(@user.reload.email).to eq email
    end

    it "プロフィール編集：無効なユーザ情報(全て空欄)" do
      log_in_as(@user)
      expect(logged_in?).to eq true
      patch user_path(@user),
            params: { edit_element: "profile",
                      user: { name: "",
                              email: "",
                              introduction: "",
                              password: "",
                              password_confirmation: "" } }
      expect(response).to render_template 'users/edit'
      expect(response.body).to include "class=\"alert alert-danger\""
    end

    it "プロフィール編集：無効なユーザ情報(すでに登録されているメールアドレス)" do
      log_in_as(@user)
      expect(logged_in?).to eq true
      patch user_path(@user),
            params: { edit_element: "profile",
                      user: { name: "test",
                              email: "other_user@example.com",
                              introduction: "valid_introduction",
                              password: "password",
                              password_confirmation: "password" } }
      expect(response).to render_template 'users/edit'
      expect(response.body).to include "class=\"alert alert-danger\""
    end

    it "プロフィール編集：無効なユーザ情報(パスワード確認が一致しない)" do
      log_in_as(@user)
      expect(logged_in?).to eq true
      patch user_path(@user),
            params: { edit_element: "profile",
                      user: { name: "test",
                              email: "hogehoge@example.com",
                              introduction: "valid_introduction",
                              password: "password",
                              password_confirmation: "p@ssw0rd" } }
      expect(response).to render_template 'users/edit'
      expect(response.body).to include "class=\"alert alert-danger\""
    end

    it "プロフィール編集：ログインしていない" do
      name = "valid_user"
      email = "valid_email@valid.com"
      expect(@user.name).not_to eq name
      expect(@user.email).not_to eq email
      patch user_path(@user),
            params: { edit_element: "profile",
                      user: { name: name,
                              email: email,
                              introduction: "valid_introduction",
                              password: "valid_password",
                              password_confirmation: "valid_password" } }
      expect(response).to redirect_to root_path
      expect(flash.any?).to eq true
      expect(@user.reload.name).not_to eq name
      expect(@user.reload.email).not_to eq email
    end

    it "プロフィール編集：違うユーザ" do
      log_in_as(@other_user)
      expect(logged_in?).to eq true
      name = "valid_user"
      email = "valid_email@valid.com"
      patch user_path(@user),
            params: { edit_element: "profile",
                      user: { name: name,
                              email: email,
                              introduction: "valid_introduction",
                              password: "valid_password",
                              password_confirmation: "valid_password" } }
      expect(response).to redirect_to root_path
      expect(@user.reload.name).not_to eq name
      expect(@user.reload.email).not_to eq email
    end

    it "プロフィール編集：admin属性を変更" do
      log_in_as(@user)
      expect(logged_in?).to eq true
      name = "valid_user"
      email = "valid_email@valid.com"
      expect(@user.admin?).to eq false
      patch user_path(@user),
            params: { edit_element: "profile",
                      user: { name: name,
                              email: email,
                              introduction: "valid_introduction",
                              password: "valid_password",
                              password_confirmation: "valid_password",
                              admin: true } }
      expect(response).to redirect_to user_path(@user)
      expect(@user.reload.admin?).to eq false
    end

    it "プロフィール画像変更：有効なファイル形式" do
      log_in_as(@user)
      expect(logged_in?).to eq true
      expect(@user.image.attached?).to eq false
      image = fixture_file_upload('spec/factories/images/img.png', 'image/png')
      patch user_path(@user),
            params: { edit_element: "image",
                      user: { image: image } }
      expect(response).to redirect_to user_path(@user)
      expect(flash.any?).to eq true
      expect(@user.reload.image.attached?).to eq true
    end

    it "プロフィール画像変更：有効なファイル形式(管理者ユーザ)" do
      log_in_as(@admin)
      expect(logged_in?).to eq true
      expect(@user.image.attached?).to eq false
      image = fixture_file_upload('spec/factories/images/img.png', 'image/png')
      patch user_path(@user),
            params: { edit_element: "image",
                      user: { image: image } }
      expect(response).to redirect_to user_path(@user)
      expect(flash.any?).to eq true
      expect(@user.reload.image.attached?).to eq true
    end

    it "プロフィール画像変更：無効なファイル形式" do
      log_in_as(@user)
      expect(logged_in?).to eq true
      expect(@user.image.attached?).to eq false
      image = fixture_file_upload('spec/factories/images/img.txt', 'txt')
      patch user_path(@user),
            params: { edit_element: "image",
                      user: { image: image } }
      expect(response).to render_template 'users/edit'
      expect(response.body).to include "class=\"alert alert-danger\""
      expect(@user.reload.image.attached?).to eq false
    end

    it "プロフィール画像変更：ログインしていない" do
      expect(@user.image.attached?).to eq false
      image = fixture_file_upload('spec/factories/images/img.png', 'image/png')
      patch user_path(@user),
            params: { edit_element: "image",
                      user: { image: image } }
      expect(response).to redirect_to root_path
      expect(flash.any?).to eq true
      expect(@user.reload.image.attached?).to eq false
    end

    it "プロフィール画像変更：違うユーザ" do
      log_in_as(@other_user)
      expect(logged_in?).to eq true
      expect(@user.image.attached?).to eq false
      image = fixture_file_upload('spec/factories/images/img.png', 'image/png')
      patch user_path(@user),
            params: { edit_element: "image",
                      user: { image: image } }
      expect(response).to redirect_to root_path
      expect(@user.reload.image.attached?).to eq false
    end

    it "プロフィール画像削除" do
      log_in_as(@user)
      expect(logged_in?).to eq true
      expect(@user.image.attached?).to eq false
      patch user_path(@user),
            params: { edit_element: "image",
                      user: { image: nil } }
      expect(response).to redirect_to user_path(@user)
      expect(flash.any?).to eq true
      expect(@user.reload.image.attached?).to eq false
    end

    it "プロフィール画像削除：管理者ユーザ" do
      log_in_as(@admin)
      expect(logged_in?).to eq true
      expect(@user.image.attached?).to eq false
      patch user_path(@user),
            params: { edit_element: "image",
                      user: { image: nil } }
      expect(response).to redirect_to user_path(@user)
      expect(flash.any?).to eq true
      expect(@user.reload.image.attached?).to eq false
    end

    it "プロフィール画像削除：ログインしていない" do
      expect(@user.image.attached?).to eq false
      fixture_file_upload('spec/factories/images/img.png', 'image/png')
      patch user_path(@user),
            params: { edit_element: "image",
                      user: { image: nil } }
      expect(response).to redirect_to root_path
      expect(flash.any?).to eq true
      expect(@user.reload.image.attached?).to eq false
    end

    it "プロフィール画像削除：違うユーザ" do
      log_in_as(@other_user)
      expect(logged_in?).to eq true
      expect(@user.image.attached?).to eq false
      fixture_file_upload('spec/factories/images/img.png', 'image/png')
      patch user_path(@user),
            params: { edit_element: "image",
                      user: { image: nil } }
      expect(response).to redirect_to root_path
      expect(@user.reload.image.attached?).to eq false
    end
  end

  describe "deleteのテスト" do
    it "getリクエスト：ログイン状態" do
      log_in_as(@user)
      expect(logged_in?).to eq true
      get delete_user_path(@user)
      expect(response).to have_http_status(200)
      expect(response).to render_template 'users/delete'
    end

    it "getリクエスト：ログインしていない" do
      get delete_user_path(@user)
      expect(response).to redirect_to root_path
      expect(flash.any?).to eq true
    end

    it "getリクエスト：違うユーザ" do
      log_in_as(@other_user)
      expect(logged_in?).to eq true
      get delete_user_path(@user)
      expect(response).to redirect_to root_path
    end

    it "getリクエスト：管理者ユーザ" do
      log_in_as(@admin)
      expect(logged_in?).to eq true
      get delete_user_path(@user)
      expect(response).to have_http_status(200)
      expect(response).to render_template 'users/delete'
    end
  end

  describe "destroyのテスト" do
    it "ユーザ削除：ログイン状態" do
      log_in_as(@user)
      expect(logged_in?).to eq true
      expect { delete user_path(@user) }.to change { User.count }.by(-1)
      expect(response).to redirect_to root_path
    end

    it "ユーザ削除：管理者ユーザ" do
      log_in_as(@user)
      expect(logged_in?).to eq true
      expect { delete user_path(@user) }.to change { User.count }.by(-1)
      expect(response).to redirect_to root_path
    end

    it "ユーザ削除：ログインしていない" do
      expect { delete user_path(@user) }.not_to change { User.count }
      expect(response).to redirect_to root_path
      expect(flash.any?).to eq true
    end

    it "ユーザ削除：違うユーザ" do
      log_in_as(@other_user)
      expect(logged_in?).to eq true
      expect { delete user_path(@user) }.not_to change { User.count }
      expect(response).to redirect_to root_path
    end
  end

  describe "owningのテスト" do
    it "getリクエスト：ログイン状態" do
      log_in_as(@user)
      expect(logged_in?).to eq true
      get owning_user_path(@user)
      expect(response).to have_http_status(200)
      expect(response).to render_template 'shared/group_index'
    end

    it "getリクエスト：ログインしていない" do
      get owning_user_path(@user)
      expect(response).to redirect_to root_path
      expect(flash.any?).to eq true
    end
  end

  describe "belongingのテスト" do
    it "getリクエスト：ログイン状態" do
      log_in_as(@user)
      expect(logged_in?).to eq true
      get belonging_user_path(@user)
      expect(response).to have_http_status(200)
      expect(response).to render_template 'shared/group_index'
    end

    it "getリクエスト：ログインしていない" do
      get belonging_user_path(@user)
      expect(response).to redirect_to root_path
      expect(flash.any?).to eq true
    end
  end

  describe "not_achievedのテスト" do
    it "patchリクエスト：ログイン状態" do
      log_in_as(@user)
      expect(logged_in?).to eq true
      patch not_achieved_user_path(@user)
      expect(response).to have_http_status(200)
    end

    it "patchリクエスト：ログインしていない" do
      patch not_achieved_user_path(@user)
      expect(response).to redirect_to root_path
      expect(flash.any?).to eq true
    end
  end

  describe "encouragedのテスト" do
    it "patchリクエスト：ログイン状態" do
      log_in_as(@user)
      expect(logged_in?).to eq true
      patch encouraged_user_path(@user)
      expect(response).to have_http_status(200)
    end

    it "getリクエスト：ログインしていない" do
      patch encouraged_user_path(@user)
      expect(response).to redirect_to root_path
      expect(flash.any?).to eq true
    end
  end

  describe "followingのテスト" do
    it "getリクエスト：ログイン状態" do
      log_in_as(@user)
      expect(logged_in?).to eq true
      get following_user_path(@user)
      expect(response).to have_http_status(200)
      expect(response).to render_template 'shared/user_index'
    end

    it "getリクエスト：ログインしていない" do
      get following_user_path(@user)
      expect(response).to redirect_to root_path
      expect(flash.any?).to eq true
    end
  end

  describe "followersのテスト" do
    it "getリクエスト：ログイン状態" do
      log_in_as(@user)
      expect(logged_in?).to eq true
      get followers_user_path(@user)
      expect(response).to have_http_status(200)
      expect(response).to render_template 'shared/user_index'
    end

    it "getリクエスト：ログインしていない" do
      get followers_user_path(@user)
      expect(response).to redirect_to root_path
      expect(flash.any?).to eq true
    end
  end

  describe "いいねした投稿一覧のテスト" do
    it "getリクエスト：ログイン状態" do
      log_in_as(@user)
      expect(logged_in?).to eq true
      get like_feeds_user_path(@user)
      expect(response).to have_http_status(200)
      expect(response).to render_template 'users/like_feeds'
    end

    it "getリクエスト：ログインしていない" do
      get like_feeds_user_path(@user)
      expect(response).to redirect_to root_path
      expect(flash.any?).to eq true
    end
  end
end
