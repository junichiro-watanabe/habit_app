require 'rails_helper'

RSpec.describe Message, type: :model do
  let(:user) { create(:user) }
  let(:other_user) { create(:other_user) }
  let(:message) { Message.new(sender_id: user.id, receiver_id: other_user.id, content: "valid_content") }

  describe "有効性の情報" do
    it "有効な情報" do
      expect(message).to be_valid
    end

    it "sender_idが空白" do
      message.sender_id = ""
      expect(message).not_to be_valid
    end

    it "receiver_idが空白" do
      message.receiver_id = ""
      expect(message).not_to be_valid
    end

    it "contentが空白" do
      message.content = ""
      expect(message).not_to be_valid
    end

    it "contentが255文字超過" do
      message.content = "a" * 256
      expect(message).not_to be_valid
    end
  end
end
