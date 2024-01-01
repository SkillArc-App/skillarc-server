FactoryBot.define do
  factory :coach_seeker_context do
    user_id { SecureRandom.uuid }
    profile_id { SecureRandom.uuid }
  end
end
