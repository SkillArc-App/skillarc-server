FactoryBot.define do
  factory :coach do
    user_id { SecureRandom.uuid }
    email { Faker::Internet.email }
  end
end
