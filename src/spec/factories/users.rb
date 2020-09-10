FactoryBot.define do
  factory :guest, class: User do
    name { "ゲストユーザ" }
    email { "guest@example.com" }
    password { "password" }
    password_confirmation { "password" }
  end

  factory :user, class: User do
    name { "user" }
    email { "user@example.com" }
    password { "password" }
    password_confirmation { "password" }
  end

  factory :other_user, class: User do
    name { "other_user" }
    email { "other_user@example.com" }
    password { "password" }
    password_confirmation { "password" }
  end

  factory :users, class: User do
    sequence(:name) { |n| "user #{n}" }
    sequence(:email) { |n| "user_#{n}@example.com"}
    password { "password" }
    password_confirmation { "password" }
  end
end
