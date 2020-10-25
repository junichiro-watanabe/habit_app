require 'rails_helper'

RSpec.describe "StaticPages", type: :request do
  include TestHelper
  include SessionsHelper

  let(:user) { create(:user) }

  describe "homeのテスト" do
    it "getリクエスト：ログインしていない" do
      get root_path
      expect(response).to have_http_status(200)
      expect(response).to render_template('static_pages/home')
    end

    it "getリクエスト：ログイン状態" do
      log_in_as user
      expect(logged_in?).to eq true
      get root_path
      expect(response).to redirect_to user_path(user)
    end
  end
end
