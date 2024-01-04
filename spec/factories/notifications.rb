FactoryBot.define do
  factory :notification do
    user
    title { Faker::Lorem.sentence }
    body { Faker::Lorem.paragraph }
    url { "/" }
  end
end
