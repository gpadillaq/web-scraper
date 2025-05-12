FactoryBot.define do
  factory :page do
    url { "https://example.com/#{rand(1000)}" }
    title { "Example Page #{rand(100)}" }
    status { "pending" }
  end
end
