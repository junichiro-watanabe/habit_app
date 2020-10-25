require 'rails_helper'

RSpec.describe Achievement, type: :model do
  let(:user) { create(:user) }
  let(:group) { create(:group, user: user) }
  let(:belong) { Belong.new(user: user, group: group) }
  let(:achievement) { Achievement.new(belong: belong) }

  describe "有効性のテスト" do
    it "有効な情報" do
      expect(achievement).to be_valid
    end

    it "belongが空白" do
      achievement.belong = nil
      expect(achievement).not_to be_valid
    end
  end
end
