require 'rails_helper'

RSpec.describe GroupsHelper, type: :helper do
  describe "group_error_messagesのテスト" do
    it "無効なコミュニティ名が入力された場合のエラー出力" do
      errors = ["Name can't be blank"]
      expect(group_error_messages(errors).include?("コミュニティ名は空欄にできません")).to eq true
      errors = ["Name is too long (maximum is 50 characters)"]
      expect(group_error_messages(errors).include?("コミュニティ名は50文字以下にしてください")).to eq true
    end

    it "無効な習慣が入力された場合のエラー出力" do
      errors = ["Habit can't be blank"]
      expect(group_error_messages(errors).include?("習慣は空欄にできません")).to eq true
      errors = ["Habit is too long (maximum is 50 characters)"]
      expect(group_error_messages(errors).include?("習慣は50文字以下にしてください")).to eq true
    end

    it "無効な概要が入力された場合のエラー出力" do
      errors = ["Overview can't be blank"]
      expect(group_error_messages(errors).include?("概要は空欄にできません")).to eq true
      errors = ["Overview is too long (maximum is 255 characters)"]
      expect(group_error_messages(errors).include?("概要は255文字以下にしてください")).to eq true
    end
  end
end
