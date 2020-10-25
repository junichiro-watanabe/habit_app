require 'rails_helper'

RSpec.describe Micropost, type: :model do
  let(:user) { create(:user) }
  let(:micropost) { Micropost.new(user: user, content: "valid_content") }

  describe "有効性のテスト" do
    it "有効な情報" do
      expect(micropost).to be_valid
    end

    it "userが空白" do
      micropost.user = nil
      expect(micropost).not_to be_valid
    end

    it "contentが空白" do
      micropost.content = nil
      expect(micropost).not_to be_valid
    end

    it "contentが255文字超過" do
      micropost.content = "a" * 256
      expect(micropost).not_to be_valid
    end
  end
end
