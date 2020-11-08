require 'rails_helper'

RSpec.describe Notification, type: :model do
  let(:user) { create(:user) }
  let(:other_user) { create(:other_user) }
  let(:relationship) { Relationship.new(follower: user, followed: other_user) }
  let(:belong) { Belong.new(user: user, group: group) }
  let(:micropost) { Micropost.create(user: other_user, content: "valid_content") }
  let(:like) { Like.new(user: user, micropost: micropost) }
  let(:message) { Message.new(sender_id: user.id, receiver_id: other_user.id, content: "valid_content") }

  describe "有効性のテスト" do
    it "有効な情報：フォローしたとき" do
    end

    it "有効な情報：コミュニティに参加したとき" do
    end

    it "有効な情報：投稿をいいねしたとき" do
    end

    it "有効な情報：メッセージを送ったとき" do
    end

    it "無効な情報：visitor_idが空白" do
    end

    it "無効な情報：visited_idが空白" do
    end

    it "無効な情報：actionが空白" do
    end
  end
end
