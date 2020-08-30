require 'rails_helper'

RSpec.describe UsersHelper, type: :helper do
  include UsersHelper

  describe "user_error_messagesのテスト"
    it "無効な名前が入力された場合のエラー出力" do
      errors = ["Name can't be blank"]
      error = user_error_messages(errors)
      expect(error.include?("名前は空白にできません")).to eq true

      errors = ["Name is too long (maximum is 50 characters)"]
      error = user_error_messages(errors)
      expect(error.include?("名前は50文字以下にしてください")).to eq true
    end

    it "無効な名前が入力された場合のエラー出力" do
      errors = ["Email can't be blank", "Email is invalid"]
      error = user_error_messages(errors)
      expect(error.include?("メールアドレスは空白にできません")).to eq true
      errors = ["Email has already been taken"]
      error = user_error_messages(errors)
      expect(error.include?("既にそのメールアドレスは使用されています")).to eq true
      errors = ["Email is too long (maximum is 255 characters)"]
      error = user_error_messages(errors)
      expect(error.include?("メールアドレスは255文字以下にしてください")).to eq true
      errors = ["Email is invalid"]
      error = user_error_messages(errors)
      expect(error.include?("メールアドレスが不正な値です")).to eq true
    end

    it "無効なパスワードが入力された場合のエラー出力" do
      errors = ["Password can't be blank"]
      error = user_error_messages(errors)
      expect(error.include?("パスワードは空白にできません")).to eq true
      errors = ["Password is too short (minimum is 8 characters)"]
      error = user_error_messages(errors)
      expect(error.include?("パスワードは8文字以上に設定してください")).to eq true
    end
end
