require 'rails_helper'

RSpec.describe "Belongs", type: :request do
  include TestHelper
  include SessionsHelper

  before do
    @user = create(:user)
    @group = create(:group, user: @user)
    2.times do |n|
      eval("@user_#{n + 1} = create(:users)")
    end
    @user_2.belong(@group)
  end

  describe "updateのテスト" do
    it "参加する：ログイン状態" do
      log_in_as(@user_1)
      expect(logged_in?).to eq true
      expect { patch belong_path(@group) }.to change { Belong.count }.by(+1)
    end

    it "参加する：ログインしていない" do
      expect { patch belong_path(@group) }.not_to change { Belong.count }
      expect(response).to redirect_to root_path
      expect(flash.any?).to eq true
    end
  end

  describe "destroyのテスト" do
    it "脱退する：ログイン状態" do
      log_in_as(@user_2)
      expect(logged_in?).to eq true
      expect { delete belong_path(@group) }.to change { Belong.count }.by(-1)
    end

    it "脱退する：ログインしていない" do
      expect { delete belong_path(@group) }.not_to change { Belong.count }
      expect(response).to redirect_to root_path
      expect(flash.any?).to eq true
    end
  end
end
