FactoryBot.define do
  factory :training_provider_profile do
    id { SecureRandom.uuid }

    user
    training_provider
  end
end
