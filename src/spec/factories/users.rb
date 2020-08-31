FactoryBot.define do
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
end
