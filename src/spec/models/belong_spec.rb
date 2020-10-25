require 'rails_helper'

RSpec.describe Belong, type: :model do
  let(:user) { create(:user) }
  let(:group) { create(:group, user: user) }
  let(:belong) { Belong.new(user: user, group: group) }

  describe "有効性のテスト" do
    it "有効な情報" do
      expect(belong).to be_valid
    end

    it "userが空白" do
      belong.user = nil
      expect(belong).not_to eq be_valid
    end

    it "groupが空白" do
      belong.group = nil
      expect(belong).not_to eq be_valid
    end
  end
end
