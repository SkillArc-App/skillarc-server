FactoryBot.define do
  factory :user do
    id { SecureRandom.uuid }
    email { Faker::Internet.email }
    onboarding_sessions do
      [
        build(:onboarding_session)
      ]
    end
  end
end
