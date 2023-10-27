FactoryBot.define do
  factory :seeker_training_provider do
    id { SecureRandom.uuid }

    program
    training_provider
    user
  end
end
