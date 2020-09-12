FactoryBot.define do
  factory :group, class: Group do
    name { "group" }
    habit { "habit" }
    overview { "overview" }
  end

  factory :groups, class: Group do
    sequence(:name) { |n| "group#{n}" }
    sequence(:habit) { |n| "habit#{n}" }
    sequence(:overview) { |n| "overview#{n}" }
  end
end
