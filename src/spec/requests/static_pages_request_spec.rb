require 'rails_helper'

RSpec.describe "StaticPages", type: :request do
  describe "homeのテスト" do
    it "getリクエスト" do
      get root_path
      expect(response).to have_http_status(200)
      expect(response).to render_template('static_pages/home')
    end
  end

end
