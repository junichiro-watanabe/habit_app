FactoryBot.define do
  factory :group, class: Group do
    name { "group" }
    habit { "habit" }
    overview { "overview" }
  end

  factory :groups, class: Group do
    sequence(:name, 1) { |n| "group#{n}" }
    sequence(:habit, 1) { |n| "habit#{n}" }
    sequence(:overview, 1) { |n| "overview#{n}" }
  end
end
