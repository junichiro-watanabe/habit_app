require 'rails_helper'

RSpec.describe "Relationships", type: :request do
  include TestHelper
  include SessionsHelper

  before do
    @user = create(:user)
    @other_user = create(:other_user)
  end

  describe "updateのテスト" do
    it "フォロー：ログイン状態" do
      log_in_as(@user)
      expect(logged_in?).to eq true
      expect(@user.following?(@other_user)).to eq false
      expect { patch relationship_path(@other_user) }.to change { Relationship.count }.by(+1)
      expect(@user.following?(@other_user)).to eq true
    end

    it "フォロー：ログインしていない" do
      expect(@user.following?(@other_user)).to eq false
      expect { patch relationship_path(@other_user) }.not_to change { Relationship.count }
      expect(@user.following?(@other_user)).to eq false
      expect(response).to redirect_to root_path
      expect(flash.any?).to eq true
    end

    it "自分をフォロー" do
      log_in_as(@user)
      expect(logged_in?).to eq true
      expect(@user.following?(@user)).to eq false
      expect { patch relationship_path(@user) }.not_to change { Relationship.count }
      expect(@user.following?(@user)).to eq false
    end
  end

  describe "destroyのテスト" do
    let(:relationship) { Relationship.create(follower: @user, followed: @other_user) }
    it "フォローを外す：ログイン状態" do
      relationship
      log_in_as(@user)
      expect(logged_in?).to eq true
      expect(@user.following?(@other_user)).to eq true
      expect { delete relationship_path(@other_user) }.to change { Relationship.count }.by(-1)
      expect(@user.following?(@other_user)).to eq false
    end

    it "フォローを外す：ログインしていない" do
      relationship
      expect(@user.following?(@other_user)).to eq true
      expect { delete relationship_path(@other_user) }.not_to change { Relationship.count }
      expect(@user.following?(@other_user)).to eq true
      expect(response).to redirect_to root_path
      expect(flash.any?).to eq true
    end
  end
end
