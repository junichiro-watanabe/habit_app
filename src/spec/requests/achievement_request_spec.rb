require 'rails_helper'

RSpec.describe "Achievements", type: :request do
  include TestHelper
  include SessionsHelper

  before do
    @user = create(:user)
    @group = create(:group, user:@user)
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
      expect{ patch achievement_path(@group) }.to change{ @user_1.achieved?(@group) }.to(true)
      expect{ patch achievement_path(@group) }.to change{ @user_1.achieved?(@group) }.to(false)
    end

    it "達成状況の切り替え：ログインしていない" do
      expect(@user_1.achieved?(@group)).to eq false
      expect{ patch achievement_path(@group) }.not_to change{ @user_1.achieved?(@group) }
      expect(response).to redirect_to login_path
      expect(flash.any?).to eq true
    end

    it "達成状況の切り替え：所属していない" do

    end
  end
end
