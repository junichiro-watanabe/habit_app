FactoryBot.define do
  factory :contact, class: Contact do
    name { "お問い合わせユーザ" }
    email { "user@example.com" }
    subject { "件名" }
    text { "お問い合わせ内容" }
  end

  factory :contact2, class: Contact do
    name { "お問い合わせユーザ" }
    email { "user@example.com" }
    subject { "件名" }
    text { "お問い合わせ内容" }
  end
end
