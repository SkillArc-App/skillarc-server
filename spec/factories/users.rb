FactoryBot.define do
  factory :user do
    id { SecureRandom.uuid }
    onboarding_sessions { 
      [
        build(:onboarding_session)
      ]
    }
  end
end