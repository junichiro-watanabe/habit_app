require 'rails_helper'

RSpec.describe "Microposts", type: :request do
  include TestHelper
  include SessionsHelper

  before do
    @user = create(:user)
    @other_user = create(:other_user)
    @admin = create(:admin)
    @group = create(:group, user: @user)
    @user.belong(@group)
    @other_user.belong(@group)
    @user.toggle_achieved(@group)
    @user_micropost = Micropost.find_by(user: @user)
    @other_user.toggle_achieved(@group)
    @other_user_micropost = Micropost.find_by(user: @other_user)
  end

  describe "destroyのテスト" do
    it "投稿削除" do
      log_in_as(@user)
      expect(logged_in?).to eq true
      expect { delete micropost_path(@user_micropost) }.to change { Micropost.count }.by(-1)
      expect(request).to redirect_to user_path(@user)
      expect(flash.any?).to eq true
    end

    it "投稿削除：ログインしていない" do
      expect { delete micropost_path(@user_micropost) }.not_to change { Micropost.count }
      expect(request).to redirect_to root_path
      expect(flash.any?).to eq true
    end

    it "投稿削除：違うユーザ" do
      log_in_as(@user)
      expect(logged_in?).to eq true
      expect { delete micropost_path(@other_user_micropost) }.not_to change { Micropost.count }
      expect(request).to redirect_to root_path
    end

    it "投稿削除：管理者ユーザ" do
      log_in_as(@admin)
      expect(logged_in?).to eq true
      expect { delete micropost_path(@user_micropost) }.to change { Micropost.count }.by(-1)
      expect(request).to redirect_to user_path(@admin)
      expect(flash.any?).to eq true
    end
  end
end
