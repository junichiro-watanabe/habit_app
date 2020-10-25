require 'rails_helper'

RSpec.describe Contact, type: :model do
  let(:contact) do
    Contact.new(name: "valid_user",
                email: "valid_email@valid.com",
                subject: "valid_subject",
                text: "valid_text")
  end

  describe "有効性のテスト" do
    it "有効な問い合わせ" do
      expect(contact).to be_valid
    end

    it "ユーザ名が空白" do
      contact.name = ""
      expect(contact).not_to be_valid
    end

    it "ユーザ名が50文字超過" do
      contact.name = "a" * 51
      expect(contact).not_to be_valid
    end

    it "メールアドレスが空白" do
      contact.email = ""
      expect(contact).not_to be_valid
    end

    it "メールアドレスが255文字超過" do
      contact.email = "a" * 256 + "@aaa.com"
      expect(contact).not_to be_valid
    end

    it "メールアドレスがフォーマットに当てはまらない" do
      contact.email = "aaa"
      expect(contact).not_to be_valid
    end

    it "件名が空白" do
      contact.subject = ""
      expect(contact).not_to be_valid
    end

    it "件名が50字超過" do
      contact.subject = "a" * 51
      expect(contact).not_to be_valid
    end

    it "問い合わせ内容が空白" do
      contact.text = ""
      expect(contact).not_to be_valid
    end

    it "問い合わせ内容が1000字超過" do
      contact.text = "a" * 1001
      expect(contact).not_to be_valid
    end
  end
end
