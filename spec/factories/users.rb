FactoryBot.define do
  factory :user do
    id { SecureRandom.uuid }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email }
    onboarding_sessions do
      [
        build(:onboarding_session)
      ]
    end
  end
end
