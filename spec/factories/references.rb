FactoryBot.define do
  factory :reference do
    id { SecureRandom.uuid }
    seeker

    author_profile { build(:training_provider_profile) }
    training_provider
    seeker_profile { build(:profile) }
    reference_text { "This is a reference" }
  end
end
