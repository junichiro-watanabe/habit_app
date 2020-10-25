require 'rails_helper'

RSpec.describe Like, type: :model do
  let(:user) { create(:user) }
  let(:other_user) { create(:other_user) }
  let(:micropost) { Micropost.create(user: other_user, content: "valid_content") }
  let(:like) { Like.new(user: user, micropost: micropost) }

  describe "有効性の確認" do
    it "有効な情報" do
      expect(like).to be_valid
    end

    it "user_idが空白" do
      like.user_id = ""
      expect(like).not_to be_valid
    end

    it "micropost_idが空白" do
      like.micropost_id = ""
      expect(like).not_to be_valid
    end
  end
end
