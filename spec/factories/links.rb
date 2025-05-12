FactoryBot.define do
  factory :link do
    url { "https://link#{rand(1000)}.com" }
    name { "Link Name #{rand(100)}" }
    association :page
  end
end
