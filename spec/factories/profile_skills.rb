FactoryBot.define do
  factory :profile_skill do
    id { SecureRandom.uuid }
    master_skill
    seeker
  end
end
