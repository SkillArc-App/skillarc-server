FactoryBot.define do
  factory :coaches__coach_seeker_context, class: "Coaches::CoachSeekerContext" do
    user_id { SecureRandom.uuid }
    profile_id { SecureRandom.uuid }
  end
end
