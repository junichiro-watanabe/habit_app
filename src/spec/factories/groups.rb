FactoryBot.define do
  factory :group, class: Group do
    name { "group" }
    habit { "habit" }
    overview { "overview" }
  end

  factory :groups, class: Group do
    sequence(:name, 2) { |n| "group#{n}" }
    sequence(:habit, 2) { |n| "habit#{n}" }
    sequence(:overview, 2) { |n| "overview#{n}" }
  end
end
