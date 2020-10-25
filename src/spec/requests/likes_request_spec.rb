require 'rails_helper'

RSpec.describe "Likes", type: :request do
  include TestHelper
  include SessionsHelper

  before do
    @user = create(:user)
    @other_user = create(:other_user)
    @group = create(:group, user: @user)
    @user.belong(@group)
    @other_user.belong(@group)
    @user.toggle_achieved(@group)
    @user_micropost = Micropost.find_by(user: @user)
    @other_user.toggle_achieved(@group)
    @other_user_micropost = Micropost.find_by(user: @other_user)
    @other_user.like(@user_micropost)
  end

  describe "showのテスト" do
    it "getリクエスト：ログイン状態" do
      log_in_as(@user)
      expect(logged_in?).to eq true
      get like_path(@other_user_micropost)
      expect(response).to have_http_status(200)
      expect(response).to render_template 'likes/show'
    end

    it "getリクエスト：ログインしていない" do
      get like_path(@other_user_micropost)
      expect(response).to redirect_to root_path
      expect(flash.any?).to eq true
    end
  end

  describe "updateのテスト" do
    it "いいね成功：ログイン状態" do
      log_in_as(@user)
      expect(logged_in?).to eq true
      expect(@user.like?(@other_user_micropost)).to eq false
      expect { patch like_path(@other_user_micropost) }.to change { Like.count }.by(+1)
      expect(@user.like?(@other_user_micropost)).to eq true
    end

    it "いいね成功：ログインしていない" do
      expect(@user.like?(@other_user_micropost)).to eq false
      expect { patch like_path(@other_user_micropost) }.not_to change { Like.count }
      expect(@user.like?(@other_user_micropost)).to eq false
      expect(response).to redirect_to root_path
      expect(flash.any?).to eq true
    end

    it "自分の投稿をいいね" do
      log_in_as(@user)
      expect(logged_in?).to eq true
      expect(@user.like?(@user_micropost)).to eq false
      expect { patch like_path(@user_micropost) }.not_to change { Like.count }
      expect(@user.like?(@user_micropost)).to eq false
    end
  end

  describe "destroyのテスト" do
    it "いいね取り消し：ログイン状態" do
      log_in_as(@other_user)
      expect(logged_in?).to eq true
      expect(@other_user.like?(@user_micropost)).to eq true
      expect { delete like_path(@user_micropost) }.to change { Like.count }.by(-1)
      expect(@other_user.like?(@user_micropost)).to eq false
    end

    it "いいね取り消し：ログインしていない" do
      expect(@other_user.like?(@user_micropost)).to eq true
      expect { delete like_path(@user_micropost) }.not_to change { Like.count }
      expect(@other_user.like?(@user_micropost)).to eq true
      expect(response).to redirect_to root_path
      expect(flash.any?).to eq true
    end
  end
end
