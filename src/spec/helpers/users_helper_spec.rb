require 'rails_helper'

RSpec.describe UsersHelper, type: :helper do
  describe "user_error_messagesのテスト"
  it "無効な名前が入力された場合のエラー出力" do
    errors = ["Name can't be blank"]
    expect(user_error_messages(errors).include?("名前は空白にできません")).to eq true

    errors = ["Name is too long (maximum is 50 characters)"]
    expect(user_error_messages(errors).include?("名前は50文字以下にしてください")).to eq true
  end

  it "無効な名前が入力された場合のエラー出力" do
    errors = ["Email can't be blank", "Email is invalid"]
    expect(user_error_messages(errors).include?("メールアドレスは空白にできません")).to eq true
    errors = ["Email has already been taken"]
    expect(user_error_messages(errors).include?("既にそのメールアドレスは使用されています")).to eq true
    errors = ["Email is too long (maximum is 255 characters)"]
    expect(user_error_messages(errors).include?("メールアドレスは255文字以下にしてください")).to eq true
    errors = ["Email is invalid"]
    expect(user_error_messages(errors).include?("メールアドレスが不正な値です")).to eq true
  end

  it "無効なパスワードが入力された場合のエラー出力" do
    errors = ["Password can't be blank"]
    expect(user_error_messages(errors).include?("パスワードは空白にできません")).to eq true
    errors = ["Password is too short (minimum is 8 characters)"]
    expect(user_error_messages(errors).include?("パスワードは8文字以上に設定してください")).to eq true
  end
end
