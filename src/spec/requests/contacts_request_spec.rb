require 'rails_helper'

RSpec.describe "Contacts", type: :request do
  include SessionsHelper
  include TestHelper

  before do
    @user = create(:user)
    @admin = create(:admin)
    @contact = create(:contact)
    @contact2 = create(:contact2)
  end

  describe "indexのテスト" do
    it "getリクエスト：管理者ユーザ" do
      log_in_as(@admin)
      expect(logged_in?).to eq true
      get contacts_path
      expect(response).to have_http_status(200)
      expect(response).to render_template 'contacts/index'
    end

    it "getリクエスト：管理者ユーザではない" do
      log_in_as(@user)
      expect(logged_in?).to eq true
      get contacts_path
      expect(response).to redirect_to root_path
    end

    it "getリクエスト：ログインしていない" do
      get contacts_path
      expect(response).to redirect_to root_path
      expect(flash.any?).to eq true
    end
  end

  describe "showのテスト" do
    it "getリクエスト：管理者ユーザ" do
      log_in_as(@admin)
      expect(logged_in?).to eq true
      get contact_path(@contact)
      expect(response).to have_http_status(200)
      expect(response).to render_template 'contacts/show'
    end

    it "getリクエスト：管理者ユーザではない" do
      log_in_as(@user)
      expect(logged_in?).to eq true
      get contact_path(@contact)
      expect(response).to redirect_to root_path
    end

    it "getリクエスト：ログインしていない" do
      get contact_path(@contact)
      expect(response).to redirect_to root_path
      expect(flash.any?).to eq true
    end
  end

  describe "createのテスト" do
    it "問い合わせ成功" do
      expect do
        post contacts_path,
             params: { contact: { name: "valid_user",
                                  email: "valid_email@valid.com",
                                  subject: "valid_subject",
                                  text: "valid_text" } }
      end.to change { Contact.count }.by(+1)
      expect(response).to redirect_to root_path
      expect(flash.any?).to eq true
    end

    it "問い合わせ失敗" do
      expect do
        post contacts_path,
             params: { contact: { name: "",
                                  email: "",
                                  subject: "",
                                  text: "" } }
      end.not_to change { Contact.count }
      expect(response).to render_template 'static_pages/home'
      expect(response.body).to include "class=\"alert alert-danger\""
    end
  end

  describe "destroyのテスト" do
    it "お問い合わせ削除：管理者ユーザ" do
      log_in_as(@admin)
      expect(logged_in?).to eq true
      expect { delete contact_path(@contact) }.to change { Contact.count }.by(-1)
      expect(response).to redirect_to user_path(@admin)
      expect(flash.any?).to eq true
    end

    it "お問い合わせ削除：管理者ユーザでない" do
      log_in_as(@user)
      expect(logged_in?).to eq true
      expect { delete contact_path(@contact) }.not_to change { Contact.count }
      expect(response).to redirect_to root_path
    end

    it "お問い合わせ削除：管理者ユーザでない" do
      expect { delete contact_path(@contact) }.not_to change { Contact.count }
      expect(response).to redirect_to root_path
      expect(flash.any?).to eq true
    end
  end
end
