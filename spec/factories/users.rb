FactoryBot.define do
  factory :user do
    id { SecureRandom.uuid }
    email { "hannah@blocktrainapp.com" }
    onboarding_sessions do
      [
        build(:onboarding_session)
      ]
    end
  end
end
