FactoryBot.define do
  factory :admin, class: User do
    name { "管理者ユーザ" }
    email { "admin@example.com" }
    introduction { "admin_introduction" }
    password { "password" }
    password_confirmation { "password" }
    admin { true }
  end

  factory :guest, class: User do
    name { "ゲストユーザ" }
    email { "guest@example.com" }
    introduction { "guest_introduction" }
    password { "password" }
    password_confirmation { "password" }
  end

  factory :user, class: User do
    name { "user" }
    email { "user@example.com" }
    introduction { "user_introduction" }
    password { "password" }
    password_confirmation { "password" }
  end

  factory :other_user, class: User do
    name { "other_user" }
    email { "other_user@example.com" }
    introduction { "other_user_introduction" }
    password { "password" }
    password_confirmation { "password" }
  end

  factory :users, class: User do
    sequence(:name, 1) { |n| "user #{n}" }
    sequence(:email, 1) { |n| "user_#{n}@example.com" }
    sequence(:introduction, 1) { |n| "user_#{n}_introduction" }
    password { "password" }
    password_confirmation { "password" }
  end
end
