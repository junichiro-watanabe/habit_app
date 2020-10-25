require 'rails_helper'

RSpec.describe Relationship, type: :model do
  let(:user) { create(:user) }
  let(:other_user) { create(:other_user) }
  let(:relationship) { Relationship.new(follower: user, followed: other_user) }

  describe "有効性のテスト" do
    it "有効な情報" do
      expect(relationship).to be_valid
    end

    it "followerが空白" do
      relationship.follower = nil
      expect(relationship).not_to be_valid
    end

    it "followedが空白" do
      relationship.followed = nil
      expect(relationship).not_to be_valid
    end
  end
end
