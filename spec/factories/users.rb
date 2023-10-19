FactoryBot.define do
  factory :user do
    id { SecureRandom.uuid }
    onboarding_sessions do
      [
        build(:onboarding_session)
      ]
    end
  end
end
