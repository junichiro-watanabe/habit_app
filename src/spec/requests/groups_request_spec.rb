require 'rails_helper'

RSpec.describe "Groups", type: :request do
  include SessionsHelper
  include TestHelper

  before do
    @user = create(:user)
    @other_user = create(:other_user)
    @admin = create(:admin)
    @group = create(:group, user: @user)
    30.times do |n|
      eval("@group_#{n} = create(:groups, user: @user)")
    end
  end

  describe "indexのテスト" do
    it "getリクエスト：ログイン状態" do
      log_in_as(@user)
      expect(logged_in?).to eq true
      get groups_path
      expect(response).to have_http_status(200)
      expect(response).to render_template 'shared/group_index'
    end

    it "getリクエスト：ログインしていない" do
      get groups_path
      expect(response).to redirect_to root_path
      expect(flash.any?).to eq true
    end
  end

  describe "newのテスト" do
    it "getリクエスト：ログイン状態" do
      log_in_as(@user)
      expect(logged_in?).to eq true
      get '/create_group'
      expect(response).to have_http_status(200)
      expect(response).to render_template 'groups/new'
    end

    it "getリクエスト：ログインしていない" do
      get '/create_group'
      expect(response).to redirect_to root_path
      expect(flash.any?).to eq true
    end
  end

  describe "createのテスト" do
    it "コミュニティ作成：有効なコミュニティ情報" do
      log_in_as(@user)
      expect(logged_in?).to eq true
      expect do
        post groups_path,
             params: { group: { name: "valid_name",
                                habit: "valid_habit",
                                overview: "valid_overview" } }
      end.to change { Group.count }.by(+1)
      group = Group.last
      expect(response).to redirect_to group_path(group)
      expect(flash.any?).to eq true
    end

    it "コミュニティ作成：無効なコミュニティ情報(全て空欄)" do
      log_in_as(@user)
      expect(logged_in?).to eq true
      expect do
        post groups_path,
             params: { group: { name: "",
                                habit: "",
                                overview: "" } }
      end.to change { Group.count }.by(+0)
      expect(response).to render_template 'groups/new'
      expect(response.body).to include "class=\"alert alert-danger\""
    end

    it "コミュニティ作成：ログインしていない" do
      expect do
        post groups_path,
             params: { group: { name: "valid_name",
                                habit: "valid_habit",
                                overview: "valid_overview" } }
      end.to change { Group.count }.by(+0)
      expect(response).to redirect_to root_path
      expect(flash.any?).to eq true
    end
  end

  describe "show" do
    it "getリクエスト：ログイン状態" do
      log_in_as(@user)
      expect(logged_in?).to eq true
      get group_path(@group)
      expect(response).to have_http_status(200)
      expect(response).to render_template 'groups/show'
    end

    it "getリクエスト：ログインしていない" do
      get group_path(@group)
      expect(response).to redirect_to root_path
      expect(flash.any?).to eq true
    end
  end

  describe "edit" do
    it "getリクエスト：ログイン状態" do
      log_in_as(@user)
      expect(logged_in?).to eq true
      get edit_group_path(@group)
      expect(response).to have_http_status(200)
      expect(response).to render_template 'groups/edit'
    end

    it "getリクエスト：ログインしていない" do
      get edit_group_path(@group)
      expect(response).to redirect_to root_path
      expect(flash.any?).to eq true
    end

    it "getリクエスト：オーナ以外のユーザ" do
      log_in_as(@other_user)
      expect(logged_in?).to eq true
      get edit_group_path(@group)
      expect(response).to redirect_to groups_path
    end
  end

  describe "edit_image" do
    it "getリクエスト：ログイン状態" do
      log_in_as(@user)
      expect(logged_in?).to eq true
      get edit_image_group_path(@group)
      expect(response).to have_http_status(200)
      expect(response).to render_template 'groups/edit_image'
    end

    it "getリクエスト：ログインしていない" do
      get edit_image_group_path(@group)
      expect(response).to redirect_to root_path
      expect(flash.any?).to eq true
    end

    it "getリクエスト：オーナ以外のユーザ" do
      log_in_as(@other_user)
      expect(logged_in?).to eq true
      get edit_image_group_path(@group)
      expect(response).to redirect_to groups_path
    end

    it "getリクエスト：管理者ユーザ" do
      log_in_as(@admin)
      expect(logged_in?).to eq true
      get edit_group_path(@group)
      expect(response).to have_http_status(200)
      expect(response).to render_template 'groups/edit'
    end
  end

  describe "updateのテスト" do
    it "コミュニティ情報編集：有効なコミュニティ情報" do
      log_in_as(@user)
      expect(logged_in?).to eq true
      name = "valid_name"
      habit = "valid_habit"
      overview = "valid_overview"
      expect(@group.name).not_to eq name
      expect(@group.habit).not_to eq habit
      expect(@group.overview).not_to eq overview
      patch group_path(@group),
            params: { edit_element: "group",
                      group: { name: name,
                               habit: habit,
                               overview: overview } }
      expect(response).to redirect_to group_path(@group)
      expect(flash.any?).to eq true
      expect(@group.reload.name).to eq name
      expect(@group.reload.habit).to eq habit
      expect(@group.reload.overview).to eq overview
    end

    it "コミュニティ情報編集：無効なコミュニティ情報" do
      log_in_as(@user)
      expect(logged_in?).to eq true
      patch group_path(@group),
            params: { edit_element: "group",
                      group: { name: "",
                               habit: "",
                               overview: "" } }
      expect(response).to render_template 'groups/edit'
      expect(response.body).to include "class=\"alert alert-danger\""
    end

    it "コミュニティ情報編集：ログインしていない" do
      name = "valid_name"
      habit = "valid_habit"
      overview = "valid_overview"
      expect(@group.name).not_to eq name
      expect(@group.habit).not_to eq habit
      expect(@group.overview).not_to eq overview
      patch group_path(@group),
            params: { edit_element: "group",
                      group: { name: name,
                               habit: habit,
                               overview: overview } }
      expect(response).to redirect_to root_path
      expect(flash.any?).to eq true
      expect(@group.name).not_to eq name
      expect(@group.habit).not_to eq habit
      expect(@group.overview).not_to eq overview
    end

    it "コミュニティ情報編集：オーナ以外のユーザ" do
      log_in_as(@other_user)
      expect(logged_in?).to eq true
      name = "valid_name"
      habit = "valid_habit"
      overview = "valid_overview"
      expect(@group.name).not_to eq name
      expect(@group.habit).not_to eq habit
      expect(@group.overview).not_to eq overview
      patch group_path(@group),
            params: { edit_element: "group",
                      group: { name: name,
                               habit: habit,
                               overview: overview } }
      expect(@group.name).not_to eq name
      expect(@group.habit).not_to eq habit
      expect(@group.overview).not_to eq overview
      expect(response).to redirect_to groups_path
    end

    it "コミュニティ情報編集：有効なコミュニティ情報(管理者ユーザ)" do
      log_in_as(@admin)
      expect(logged_in?).to eq true
      name = "valid_name"
      habit = "valid_habit"
      overview = "valid_overview"
      expect(@group.name).not_to eq name
      expect(@group.habit).not_to eq habit
      expect(@group.overview).not_to eq overview
      patch group_path(@group),
            params: { edit_element: "group",
                      group: { name: name,
                               habit: habit,
                               overview: overview } }
      expect(response).to redirect_to group_path(@group)
      expect(flash.any?).to eq true
      expect(@group.reload.name).to eq name
      expect(@group.reload.habit).to eq habit
      expect(@group.reload.overview).to eq overview
    end

    it "コミュニティ画像編集：有効なファイル形式" do
      log_in_as(@user)
      expect(logged_in?).to eq true
      expect(@group.image.attached?).to eq false
      image = fixture_file_upload('spec/factories/images/img.png', 'image/png')
      patch group_path(@group),
            params: { edit_element: "image",
                      group: { image: image } }
      expect(response).to redirect_to group_path(@group)
      expect(flash.any?).to eq true
      expect(@group.reload.image.attached?).to eq true
    end

    it "コミュニティ画像編集：無効なファイル形式" do
      log_in_as(@user)
      expect(logged_in?).to eq true
      expect(@group.image.attached?).to eq false
      image = fixture_file_upload('spec/factories/images/img.txt', 'txt')
      patch group_path(@group),
            params: { edit_element: "image",
                      group: { image: image } }
      expect(response).to render_template 'groups/edit'
      expect(response.body).to include "class=\"alert alert-danger\""
      expect(@group.reload.image.attached?).to eq false
    end

    it "コミュニティ画像編集：ログインしていない" do
      expect(@group.image.attached?).to eq false
      image = fixture_file_upload('spec/factories/images/img.txt', 'txt')
      patch group_path(@group),
            params: { edit_element: "image",
                      group: { image: image } }
      expect(response).to redirect_to root_path
      expect(flash.any?).to eq true
      expect(@group.reload.image.attached?).to eq false
    end

    it "コミュニティ画像編集：オーナ以外のユーザ" do
      log_in_as(@other_user)
      expect(logged_in?).to eq true
      expect(@group.image.attached?).to eq false
      image = fixture_file_upload('spec/factories/images/img.txt', 'txt')
      patch group_path(@group),
            params: { edit_element: "image",
                      group: { image: image } }
      expect(@group.reload.image.attached?).to eq false
      expect(response).to redirect_to groups_path
    end

    it "コミュニティ画像編集：有効なファイル形式(管理者ユーザ)" do
      log_in_as(@admin)
      expect(logged_in?).to eq true
      expect(@group.image.attached?).to eq false
      image = fixture_file_upload('spec/factories/images/img.png', 'image/png')
      patch group_path(@group),
            params: { edit_element: "image",
                      group: { image: image } }
      expect(response).to redirect_to group_path(@group)
      expect(flash.any?).to eq true
      expect(@group.reload.image.attached?).to eq true
    end

    it "コミュニティ画像削除" do
      log_in_as(@user)
      expect(logged_in?).to eq true
      expect(@group.image.attached?).to eq false
      fixture_file_upload('spec/factories/images/img.png', 'image/png')
      patch group_path(@group),
            params: { edit_element: "image",
                      group: { image: nil } }
      expect(response).to redirect_to group_path(@group)
      expect(flash.any?).to eq true
      expect(@group.image.attached?).to eq false
    end

    it "コミュニティ画像削除：ログインしていない" do
      expect(@group.image.attached?).to eq false
      fixture_file_upload('spec/factories/images/img.png', 'image/png')
      patch group_path(@group),
            params: { edit_element: "image",
                      group: { image: nil } }
      expect(response).to redirect_to root_path
      expect(flash.any?).to eq true
      expect(@group.image.attached?).to eq false
    end

    it "コミュニティ画像削除：オーナ以外のユーザ" do
      log_in_as(@other_user)
      expect(logged_in?).to eq true
      expect(@group.image.attached?).to eq false
      fixture_file_upload('spec/factories/images/img.png', 'image/png')
      patch group_path(@group),
            params: { edit_element: "image",
                      group: { image: nil } }
      expect(@group.image.attached?).to eq false
      expect(response).to redirect_to groups_path
    end

    it "コミュニティ画像削除：管理者ユーザ" do
      log_in_as(@admin)
      expect(logged_in?).to eq true
      expect(@group.image.attached?).to eq false
      fixture_file_upload('spec/factories/images/img.png', 'image/png')
      patch group_path(@group),
            params: { edit_element: "image",
                      group: { image: nil } }
      expect(response).to redirect_to group_path(@group)
      expect(flash.any?).to eq true
      expect(@group.image.attached?).to eq false
    end
  end

  describe "deleteのテスト" do
    it "getリクエスト：ログイン状態" do
      log_in_as(@user)
      expect(logged_in?).to eq true
      get delete_group_path(@group)
      expect(response).to have_http_status(200)
      expect(response).to render_template 'groups/delete'
    end

    it "getリクエスト：ログインしていない" do
      get delete_group_path(@group)
      expect(response).to redirect_to root_path
      expect(flash.any?).to eq true
    end

    it "getリクエスト：オーナ以外のユーザ" do
      log_in_as(@other_user)
      expect(logged_in?).to eq true
      get delete_group_path(@group)
      expect(response).to redirect_to groups_path
    end

    it "getリクエスト：管理者ユーザ" do
      log_in_as(@user)
      expect(logged_in?).to eq true
      get delete_group_path(@group)
      expect(response).to have_http_status(200)
      expect(response).to render_template 'groups/delete'
    end
  end

  describe "destroyのテスト" do
    it "コミュニティ削除" do
      log_in_as(@user)
      expect(logged_in?).to eq true
      expect { delete group_path(@group_1) }.to change { Group.count }.by(-1)
      expect(response).to redirect_to groups_path
    end

    it "コミュニティ削除：ログインしていない" do
      expect { delete group_path(@group_1) }.not_to change { Group.count }
      expect(response).to redirect_to root_path
      expect(flash.any?).to eq true
    end

    it "コミュニティ削除：オーナ以外のユーザ" do
      log_in_as(@other_user)
      expect(logged_in?).to eq true
      expect { delete group_path(@group_1) }.not_to change { Group.count }
      expect(response).to redirect_to groups_path
    end

    it "コミュニティ削除：管理者ユーザ" do
      log_in_as(@user)
      expect(logged_in?).to eq true
      expect { delete group_path(@group_1) }.to change { Group.count }.by(-1)
      expect(response).to redirect_to groups_path
    end
  end

  describe "memberのテスト" do
    it "getリクエスト：ログイン状態" do
      log_in_as(@user)
      expect(logged_in?).to eq true
      get member_group_path(@group)
      expect(response).to have_http_status(200)
      expect(response).to render_template 'shared/user_index'
    end

    it "getリクエスト：ログインしていない" do
      get member_group_path(@group)
      expect(response).to redirect_to root_path
      expect(flash.any?).to eq true
    end
  end
end
