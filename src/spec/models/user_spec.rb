require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) do
    User.new(name: "valid_user",
             email: "valid_email@valid.com",
             introduction: "valid_introduction",
             password: "valid_password",
             password_confirmation: "valid_password")
  end

  describe "有効性のテスト" do
    it "有効なユーザ情報" do
      expect(user).to be_valid
    end

    it "ユーザ名が空白" do
      user.name = ""
      expect(user).not_to be_valid
    end

    it "ユーザ名が50文字超過" do
      user.name = "a" * 51
      expect(user).not_to be_valid
    end

    it "メールアドレスが空白" do
      user.email = ""
      expect(user).not_to be_valid
    end

    it "メールアドレスが255文字超過" do
      user.email = "a" * 256 + "@aaa.com"
      expect(user).not_to be_valid
    end

    it "メールアドレスがフォーマットに当てはまらない" do
      user.email = "aaa"
      expect(user).not_to be_valid
    end

    it "パスワードが8文字未満" do
      user.password = "aaa"
      expect(user).not_to be_valid
    end

    it "自己紹介が255文字超過" do
      user.introduction = "a" * 256
      expect(user).not_to be_valid
    end
  end
end
