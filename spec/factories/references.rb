FactoryBot.define do
  factory :reference do
    id { SecureRandom.uuid }
    seeker_id { SecureRandom.uuid }

    author_profile { build(:training_provider_profile) }
    training_provider
    reference_text { "This is a reference" }
  end
end
