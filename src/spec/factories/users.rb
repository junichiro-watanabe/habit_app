FactoryBot.define do
  factory :user, class: User do
    name { "user" }
    email { "user@example.com" }
    password { "password" }
    password_confirmation { "password" }
  end
end
