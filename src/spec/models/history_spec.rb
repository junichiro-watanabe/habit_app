require 'rails_helper'

RSpec.describe History, type: :model do
  let(:user) { create(:user) }
  let(:group) { create(:group, user: user) }
  let(:belong) { Belong.new(user: user, group: group) }
  let(:achievement) { Achievement.new(belong: belong) }
  let(:history) { History.new(achievement: achievement, date: Date.today) }

  describe "有効性のテスト" do
    it "有効な情報" do
      expect(history).to be_valid
    end

    it "achievementが空白" do
      history.achievement = nil
      expect(history).not_to be_valid
    end

    it "dateが空白" do
      history.date = nil
      expect(history).not_to be_valid
    end
  end
end
