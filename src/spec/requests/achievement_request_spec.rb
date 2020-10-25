require 'rails_helper'

RSpec.describe "Achievements", type: :request do
  include TestHelper
  include SessionsHelper

  before do
    @user = create(:user)
    @group = create(:group, user: @user)
    2.times do |n|
      eval("@user_#{n + 1} = create(:users)")
    end
    @user_1.belong(@group)
  end

  describe "updateのテスト" do
    it "達成状況の切り替え：ログイン状態" do
      log_in_as(@user_1)
      expect(logged_in?).to eq true
      expect(@user_1.achieved?(@group)).to eq false
      expect { patch achievement_path(@group) }.to change { @user_1.achieved?(@group) }.to(true).and change { @user_1.microposts.count }.by(+1)
      expect { patch achievement_path(@group) }.to change { @user_1.achieved?(@group) }.to(false).and change { @user_1.microposts.count }.by(-1)
    end

    it "達成状況の切り替え：ログインしていない" do
      expect(@user_1.achieved?(@group)).to eq false
      expect { patch achievement_path(@group) }.not_to change { @user_1.achieved?(@group) }
      expect(response).to redirect_to root_path
      expect(flash.any?).to eq true
    end

    it "達成状況の切り替え：所属していない" do
      log_in_as(@user_2)
      expect { patch achievement_path(@group) }.not_to change { @user_2.achieved?(@group) }
      expect(response).to redirect_to group_path(@group)
      expect(flash.any?).to eq true
    end
  end

  describe "encourageのテスト" do
    it "煽り投稿：ログイン状態" do
      log_in_as(@user_1)
      expect(logged_in?).to eq true
      patch achievement_path(@group)
      expect { post encourage_achievement_path(@group), params: { content: "content" } }.to change { @user_1.microposts.count }.by(+1)
    end

    it "煽り投稿：ログインしていない" do
      expect(@user_1.achieved?(@group)).to eq false
      patch achievement_path(@group)
      expect { post encourage_achievement_path(@group), params: { content: "content" } }.not_to change { @user_1.microposts.count }
      expect(response).to redirect_to root_path
      expect(flash.any?).to eq true
    end

    it "煽り投稿：所属していない" do
      log_in_as(@user_2)
      patch achievement_path(@group)
      expect { post encourage_achievement_path(@group), params: { content: "content" } }.not_to change { @user_2.microposts.count }
      expect(response).to redirect_to group_path(@group)
      expect(flash.any?).to eq true
    end

    it "煽り投稿：達成していない" do
      log_in_as(@user_1)
      expect { post encourage_achievement_path(@group), params: { content: "content" } }.not_to change { @user_1.microposts.count }
      expect(response).to redirect_to group_path(@group)
      expect(flash.any?).to eq true
    end

    it "煽り投稿：文字列255文字超過" do
      log_in_as(@user_1)
      expect { post encourage_achievement_path(@group), params: { content: "a" * 255 } }.not_to change { @user_1.microposts.count }
      expect(response).to redirect_to group_path(@group)
      expect(flash.any?).to eq true
    end
  end
end
