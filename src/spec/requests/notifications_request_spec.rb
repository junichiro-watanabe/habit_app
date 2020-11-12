require 'rails_helper'

RSpec.describe "Notifications", type: :request do
  include TestHelper
  include SessionsHelper

  before do
    @user = create(:user)
    @other_user = create(:other_user)
    @group = create(:group, user: @user)
    @user.belong(@group)
    @user.toggle_achieved(@group)
    @user_micropost = Micropost.find_by(user: @user)
    @other_user.follow(@user)
    @other_user.belong(@group)
    @other_user.like(@user_micropost)
  end

  describe "updateのテスト" do
    it "お知らせ確認：ログイン状態" do
      log_in_as(@user)
      expect(logged_in?).to eq true
      expect(@user.passive_notifications.where(checked: false).count).to eq 3
      expect { patch notification_path(@user) }.to change { @user.passive_notifications.where(checked: false).count }.to(0)
    end

    it "お知らせ確認：ログインしていない" do
      expect(@user.passive_notifications.where(checked: false).count).to eq 3
      expect { patch notification_path(@user) }.not_to change { @user.passive_notifications.where(checked: false).count }
      expect(response).to redirect_to root_path
      expect(flash.any?).to eq true
    end

    it "お知らせ確認：違うユーザ" do
      log_in_as(@other_user)
      expect(logged_in?).to eq true
      expect(@user.passive_notifications.where(checked: false).count).to eq 3
      expect { patch notification_path(@user) }.not_to change { @user.passive_notifications.where(checked: false).count }
      expect(response).to redirect_to root_path
    end
  end
end
