FactoryBot.define do
  factory :onboarding_session do
    id { SecureRandom.uuid }
    started_at { Time.new(2020, 1, 1) }
  end
end
